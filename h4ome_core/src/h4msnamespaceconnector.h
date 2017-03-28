#ifndef H4MSNAMESPACECONNECTOR_H
#define H4MSNAMESPACECONNECTOR_H

#include <future>
#include <QString>
#include <QNetworkAccessManager>
#include <QNetworkRequest>

class QNetworkReply;
class H4msSessionManager;
class H4msNamespaceConnector : public QObject
{
Q_OBJECT
public:
    H4msNamespaceConnector(QString api_base_url, H4msSessionManager*);

    std::future<QString> get(QString path);
    std::future<bool> put(QString path, QString hash);

signals:
    void triggerGet(QNetworkRequest, std::promise<QString>*);
    void triggerPut(QNetworkRequest, QString, std::promise<bool>*);

private:
    QString m_api_base_url;
    QNetworkAccessManager m_network_manager;
    H4msSessionManager* m_session_manager;

private slots:
    void doGet(QNetworkRequest, std::promise<QString>*);
    void doPut(QNetworkRequest, QString, std::promise<bool>*);
};

#endif // H4MSNAMESPACECONNECTOR_H
