#include "holonstorage.h"
#include <QCryptographicHash>
#include <QFile>
#include <QDir>
#include <QUrl>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QDateTime>
#include <iostream>
#include <QJsonDocument>
#include <QJsonObject>
#include <QSet>
#include <QDataStream>
#include "api_constants.h"
#include "Promise.h"
#include <future>

HolonStorage::HolonStorage(QString root_path) :
    QObject(0), m_root_path(root_path), m_network_manager(this)
{
    QDir dir;
    dir.mkpath(root_path);
    loadSyncTable();
    connect(&m_sync_timer, SIGNAL(timeout()), this, SLOT(startUploadOfUnsyncedHolons()));
    connect(this, &HolonStorage::triggerDownload, this, &HolonStorage::download);
    connect(this, &HolonStorage::triggerUpload, this, &HolonStorage::upload);
    m_sync_timer.start(15000);
}

bool HolonStorage::uploading() const {
    return m_uploads.size() > 0;
}

void HolonStorage::setUploading(bool){}

bool HolonStorage::downloading() const{
    return m_downloads.size() > 0;
}
void HolonStorage::setDownloading(bool) {}

double HolonStorage::progress_up() const{
    qint64 bytes_total = 0;
    qint64 bytes_uploaded = 0;
    foreach(QNetworkReply* reply, m_uploads.values()) {
        bytes_total += m_bytes_total[reply];
        bytes_uploaded += m_bytes_transfered[reply];
    }
    return static_cast<double>(bytes_uploaded) / static_cast<double>(bytes_total);
}
void HolonStorage::setProgress_up(double) {}

double HolonStorage::progress_down() const{
    qint64 bytes_total = 0;
    qint64 bytes_downloaded = 0;
    foreach(QNetworkReply* reply, m_downloads.values()) {
        bytes_total += m_bytes_total[reply];
        bytes_downloaded += m_bytes_transfered[reply];
    }
    return static_cast<double>(bytes_downloaded) / static_cast<double>(bytes_total);
}
void HolonStorage::setProgress_down(double) {}

bool HolonStorage::networkAccessible() const{
    QNetworkAccessManager::NetworkAccessibility accessibility = m_network_manager.networkAccessible();
    return accessibility == QNetworkAccessManager::Accessible;
}
void HolonStorage::setNetworkAccessible(bool){}

std::future<QString> HolonStorage::get(QString _hash) {
    QFile data(file_path(_hash));
    //Promise* promise = new Promise();
    std::promise<QString>* promise = new std::promise<QString>;
    if (data.open(QFile::ReadOnly) ) {
        QTextStream in (&data);
        QString holon = in.readAll();
        promise->set_value(holon);
    } else {
        triggerDownload(_hash, promise);
    }
    return promise->get_future();
}

QString HolonStorage::put(QString holon) {
    QString holon_hash = hash(holon);
    write_file(holon_hash, holon);
    triggerUpload(holon);
    return hash(holon);
}

QString HolonStorage::hash(QString holon) const {
    QCryptographicHash hash(QCryptographicHash::Sha256);
    hash.addData(holon.toUtf8());
    // 'Qm' means 'this is a SHA-256 hash'
    // see https://github.com/multiformats/multihash
    return QString("Qm%1").arg(QString(hash.result().toHex()));
}

QString HolonStorage::file_path(QString holon_hash) const {
    return QString("%1/%2").arg(m_root_path).arg(holon_hash);
}

void HolonStorage::upload(QString holon){
    QString _hash = hash(holon);
    if(isSynced(_hash)) return;
    if(isUploading(_hash)) return;
    if(m_uploads.size() == 0) emit(uploadingChanged());
    QString url = QString("%1/holons").arg(API_BASE_URL);
    QString payload = QString("data=%1").arg(holon);
    QNetworkRequest request = QNetworkRequest(QUrl(url));
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/x-www-form-urlencoded");
    QNetworkReply* reply = m_network_manager.post(request, payload.toUtf8());
    m_uploads[_hash] = reply;
    m_hash[reply] = _hash;
    connect(reply, SIGNAL(finished()), this, SLOT(handleFinishedUpload()));
    connect(reply, SIGNAL(uploadProgress(qint64,qint64)), this, SLOT(transferProgress(qint64,qint64)));
    emit(uploadingChanged());
    emit(progress_upChanged());
}

void HolonStorage::download(QString hash, std::promise<QString>* promise){
    QString url = QString("%1/holons/%2").arg(API_BASE_URL).arg(hash);
    if(isDownloading(hash)) return;
    if(m_downloads.size() == 0) emit(downloadingChanged());
    QNetworkReply* reply = m_network_manager.get(QNetworkRequest(QUrl(url)));
    m_downloads[hash] = reply;
    m_hash[reply] = hash;
    m_download_promises[hash] = promise;
    connect(reply, SIGNAL(finished()), this, SLOT(handleFinishedDownload()));
    connect(reply, SIGNAL(downloadProgress(qint64,qint64)), this, SLOT(transferProgress(qint64,qint64)));
    emit(downloadingChanged());
    emit(progress_downChanged());
}

bool HolonStorage::isUploading(QString hash) const {
    return m_uploads.contains(hash);
}

bool HolonStorage::isDownloading(QString hash) const {
    return m_downloads.contains(hash);
}

bool HolonStorage::isSynced(QString hash) const {
    return m_last_sync.contains(hash);
}

void HolonStorage::handleFinishedDownload() {
    QNetworkReply* reply = qobject_cast<QNetworkReply*>(QObject::sender());
    QString hash = m_hash[reply];
    if(m_downloads.contains(hash)) {
        m_downloads.remove(hash);
        if(m_downloads.size() == 0) emit(downloadingChanged());
        if(reply->error() == QNetworkReply::NoError) {
            QByteArray raw_api_response = reply->readAll();
            QJsonObject api_response = QJsonDocument::fromJson(raw_api_response).object();
            QJsonObject data = api_response.value("data").toObject();
            if(data.value("hash").toString() == hash) {
                QString holon_string = data.value("data").toString();
                write_file(hash, holon_string);
                m_last_sync[hash] = QDateTime::currentDateTime().toString();
                emit holonDownloaded(hash);
                m_download_promises[hash]->set_value(holon_string);
                m_download_promises.remove(hash);
            } else {
                std::cout << "WTF?!" << std::endl;
            }

        } else {
            std::cout << reply->error() << std::endl;
            std::cout << reply->readAll().toStdString() << std::endl;
        }
    } else {
        std::cout << "WTF?!" << std::endl;
    }
    reply->deleteLater();
}

void HolonStorage::handleFinishedUpload() {
    QNetworkReply* reply = qobject_cast<QNetworkReply*>(QObject::sender());
    QString hash = m_hash[reply];
    if(m_uploads.contains(hash)) {
        m_uploads.remove(hash);
        if(m_uploads.size() == 0) emit(uploadingChanged());
        if(reply->error() == QNetworkReply::NoError) {
            m_last_sync[hash] = QDateTime::currentDateTime().toString();
            writeSyncTable();
        } else {
            std::cout << "HolonStorage: upload failed with error code: ";
            std::cout << reply->error() << std::endl;
            std::cout << "When trying to talk to " << API_BASE_URL << std::endl;
            std::cout << "See http://doc.qt.io/qt-5/qnetworkreply.html#NetworkError-enum for a description of all error codes." << std::endl;
        }
    } else {
        std::cout << "WTF?!" << std::endl;
    }
    reply->deleteLater();
}

void HolonStorage::write_file(QString filename, QString holon) {
    QFile data(file_path(filename));
    if (data.open(QFile::WriteOnly | QFile::Truncate)) {
        QTextStream out(&data);
        out << holon;
    }
}

void HolonStorage::transferProgress(qint64 bytesReceived, qint64 bytesTotal) {
    QNetworkReply* reply = qobject_cast<QNetworkReply*>(sender());

    m_bytes_transfered[reply] = bytesReceived;
    m_bytes_total[reply] = bytesTotal;

    if(m_uploads.values().contains(reply)) {
        emit(progress_upChanged());
    } else {
        emit(progress_downChanged());
    }

}


void HolonStorage::writeSyncTable() {
    QFile fileOut("sync-table.dat");
    if (fileOut.open(QIODevice::WriteOnly))
    {
       QDataStream out(&fileOut);
       out.setVersion(QDataStream::Qt_4_6);
       out << m_last_sync;
       fileOut.flush();
       fileOut.close();
    }
}

void HolonStorage::loadSyncTable() {
    QFile fileIn("sync-table.dat");
    if (fileIn.open(QIODevice::ReadOnly))
    {
        QDataStream in(&fileIn);
        in.setVersion(QDataStream::Qt_4_6);
        in >> m_last_sync;
        fileIn.close();
    }
}

void HolonStorage::startUploadOfUnsyncedHolons() {
    if(!networkAccessible()) return;
    QDir holon_storage(m_root_path);
    QSet<QString> in_files(QSet<QString>::fromList(holon_storage.entryList()));
    QSet<QString> synced(QSet<QString>::fromList(m_last_sync.keys()));
    in_files.subtract(synced);
    foreach(QString hash, in_files) {
        QFile data(file_path(hash));
        if (data.open(QFile::ReadOnly) ) {
            QTextStream in (&data);
            QString holon = in.readAll();
            upload(holon);
        }
    }
}
