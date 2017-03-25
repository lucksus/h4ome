#include "h4mssessionmanager.h"
#include "api_constants.h"
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QJsonObject>
#include <QJsonDocument>
#include <QJsonArray>
#include <iostream>

H4msSessionManager::H4msSessionManager() : m_jwt(QString("")), m_logged_in(false)
{

}

H4msSessionManager& H4msSessionManager::getInstance() {
    static H4msSessionManager hsm;
    return hsm;
}

void H4msSessionManager::login(QString email, QString password){
    QString url = QString("%1/sessions").arg(API_BASE_URL);

    QJsonObject loginData;
    loginData["email"] = email;
    loginData["password"] = password;

    QJsonDocument doc(loginData);
    QNetworkRequest request = QNetworkRequest(QUrl(url));
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
    reply = m_network_manager.post(request, doc.toJson());
    connect(reply, &QNetworkReply::finished, this, &H4msSessionManager::loginRequestFinished);
}

bool H4msSessionManager::isLoggedin() const {
    return m_logged_in;
}

QString H4msSessionManager::getJWT() const {
    return m_jwt;
}


void H4msSessionManager::loginRequestFinished() {
    QByteArray raw_api_response = reply->readAll();
    reply->deleteLater();
    QJsonObject response = QJsonDocument::fromJson(raw_api_response).object();
    if(response["meta"].toObject()["errors"].toArray().count() != 0) {

        foreach(QJsonValue e, response["meta"].toObject()["errors"].toArray()){
            emit error(e.toObject()["message"].toString());
        }
        return;
    }
    m_jwt = response["data"].toObject()["jwt"].toString();
    m_logged_in = true;
    emit loggedIn();
}

