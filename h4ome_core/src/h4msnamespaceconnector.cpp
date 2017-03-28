#include "h4msnamespaceconnector.h"
#include <QNetworkReply>
#include <QJsonDocument>
#include <QJsonObject>
#include <iostream>
#include <QThread>
#include <QTimer>
#include "h4mssessionmanager.h"

H4msNamespaceConnector::H4msNamespaceConnector(QString api_base_url, H4msSessionManager* session_manager) :
    m_api_base_url(api_base_url),
    m_session_manager(session_manager)
{
    connect(this, &H4msNamespaceConnector::triggerGet, this, &H4msNamespaceConnector::doGet);
    connect(this, &H4msNamespaceConnector::triggerPut, this, &H4msNamespaceConnector::doPut);
}


std::future<QString> H4msNamespaceConnector::get(QString path) {
    QString url = QString("%1/namespaces/%2").arg(m_api_base_url).arg(path);
    std::promise<QString>* promise = new std::promise<QString>;
    qDebug() << "Retrieving namespace" << path << "from h4ms:" << url;
    emit(triggerGet(QNetworkRequest(QUrl(url)), promise));
    return promise->get_future();
}

std::future<bool> H4msNamespaceConnector::put(QString path, QString hash) {
    QString url = QString("%1/namespaces/%2").arg(m_api_base_url).arg(path);
    std::promise<bool>* promise = new std::promise<bool>;
    qDebug() << "Retrieving namespace" << path << "from h4ms:" << url;
    emit(triggerPut(QNetworkRequest(QUrl(url)), hash, promise));
    return promise->get_future();
}

void H4msNamespaceConnector::doGet(QNetworkRequest request, std::promise<QString>* promise) {
    QNetworkReply* reply = m_network_manager.get(request);
    connect(reply, &QNetworkReply::finished, [promise, reply, this]() {
        QJsonObject response = QJsonDocument::fromJson(reply->readAll()).object();
        promise->set_value(response["data"].toObject()["hash"].toString());
        delete promise;
        reply->deleteLater();
    });
}

void H4msNamespaceConnector::doPut(QNetworkRequest request, QString hash, std::promise<bool>* promise) {
    request.setRawHeader("JWT", m_session_manager->getJWT().toLocal8Bit());
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
    QJsonObject data;
    data["hash"] = hash;
    QJsonDocument doc(data);
    QNetworkReply* reply = m_network_manager.put(request, doc.toJson());
    connect(reply, &QNetworkReply::finished, [promise, reply, hash, this]() {
        QString raw_response = reply->readAll();
        QJsonObject response = QJsonDocument::fromJson(raw_response.toLocal8Bit()).object();
        if(response["data"].toObject()["hash"].toString() == hash)
            promise->set_value(true);
        else {
            promise->set_value(false);
            qDebug() << raw_response;
        }
        delete promise;
        reply->deleteLater();
    });
}
