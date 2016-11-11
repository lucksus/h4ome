#include "holonstorage.h"
#include <QCryptographicHash>
#include <QFile>
#include <QDir>
#include <QUrl>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QDateTime>
#include <iostream>
#include "api_constants.h"

HolonStorage::HolonStorage(QString root_path) :
    QObject(0), m_root_path(root_path), m_network_manager(this)
{
    QDir dir;
    dir.mkpath(root_path);
    connect(&m_network_manager, SIGNAL(finished(QNetworkReply*)), this, SLOT(request_finished(QNetworkReply*)));
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
    foreach(const QString &hash, m_uploads.keys()) {
        //m_uploads[hash]->
    }
}
void HolonStorage::setProgress_up(double) {}

double HolonStorage::progress_down() const{

}
void HolonStorage::setProgress_down(double) {}

bool HolonStorage::networkAccessible() const{

}
void HolonStorage::setNetworkAccessible(bool){}

QString HolonStorage::get_sync(QString _hash) {
    QFile data(file_path(_hash));
    QString holon;
    if (data.open(QFile::ReadOnly) ) {
        QTextStream in (&data);
        holon = in.readAll();
    } else {
        download(_hash);
    }
    return holon;
}

QString HolonStorage::put(QString holon) {
    QString holon_hash = hash(holon);
    write_file(holon_hash, holon);
    sync(holon);
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

void HolonStorage::sync(QString holon){
    QString _hash = hash(holon);
    if(isSynced(_hash)) return;
    if(isUploading(_hash)) return;
    QString url = QString("%1/holons").arg(API_BASE_URL);
    QString payload = QString("data=%1").arg(holon);
    QNetworkReply* reply = m_network_manager.post(QNetworkRequest(QUrl(url)), payload.toUtf8());
    m_uploads[_hash] = reply;
    m_hash[reply] = _hash;
}

void HolonStorage::download(QString hash){
    QString url = QString("%1/holons/%2").arg(API_BASE_URL).arg(hash);
    if(isDownloading(hash)) return;
    QNetworkReply* reply = m_network_manager.get(QNetworkRequest(QUrl(url)));
    m_downloads[hash] = reply;
    m_hash[reply] = hash;
}

bool HolonStorage::isUploading(QString hash) const {
    return m_uploads.contains(hash);
}

bool HolonStorage::isDownloading(QString hash) const {
    return m_downloads.contains(hash);
}

bool HolonStorage::isSynced(QString hash) const {
    return m_last_sync[hash].contains(hash);
}

void HolonStorage::request_finished(QNetworkReply *reply) {
    QString hash = m_hash[reply];
    if(m_downloads.contains(hash)) {
        m_downloads.remove(hash);
        if(reply->error() == QNetworkReply::NoError) {
            write_file(hash, reply->readAll());
            m_last_sync[hash] = QDateTime::currentDateTime().toString();
        } else {
            std::cout << reply->error() << std::endl;
            std::cout << reply->readAll().toStdString() << std::endl;
        }

    }
    if(m_uploads.contains(hash)) {
        m_uploads.remove(hash);
        if(reply->error() == QNetworkReply::NoError) {
            m_last_sync[hash] = QDateTime::currentDateTime().toString();
        } else {
            std::cout << reply->error() << std::endl;
            std::cout << reply->readAll().toStdString() << std::endl;
        }
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
