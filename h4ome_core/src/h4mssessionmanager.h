#ifndef H4MSSESSIONMANAGER_H
#define H4MSSESSIONMANAGER_H

#include <QObject>
#include <QString>
#include <QNetworkAccessManager>
class QNetworkReply;
class H4msSessionManager : public QObject
{
Q_OBJECT
public:
    static H4msSessionManager& getInstance();

    void login(QString email, QString password);
    bool isLoggedin() const;
    QString getJWT() const;

signals:
    void loggedIn();
    void error(QString);

private:
    H4msSessionManager();

private slots:
    void loginRequestFinished();

private:
    QString m_jwt;
    bool m_logged_in;
    QNetworkReply* reply;
    QNetworkAccessManager m_network_manager;
};

#endif // H4MSSESSIONMANAGER_H
