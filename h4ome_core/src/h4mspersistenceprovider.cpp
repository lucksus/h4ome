#include "h4mspersistenceprovider.h"
#include <thread>
#include "holon.h"
#include "api_constants.h"
#include <iostream>
#include <QtConcurrent>
#include <memory>
#include "h4mssessionmanager.h"

H4msPersistenceProvider::H4msPersistenceProvider() :
    m_holon_storage("holons"),
    m_namespace_connector(API_BASE_URL, &H4msSessionManager::getInstance())
{

}


Holon* H4msPersistenceProvider::getHolon(QString path) {

}

void H4msPersistenceProvider::loadHolon(QString path) {
    QString namespace_name = findNamespaceByPath(path);
    if(!m_namespace_metas.contains(namespace_name)) {
        loadNamespace(namespace_name);
        return;
    }

    QString relative_path = QString(path).remove(namespace_name);

    QString holon_hash = m_namespace_metas[namespace_name].holon->getSubnodeHash(relative_path);

    //std::future<QString> namespace_future = m_holon_storage.get(holon_hash);
    //std::thread t([&namespace_future, holon_hash, path, this] () mutable {
    //   QString holon_string = namespace_future.get();
    //   m_holons[holon_hash] = new Holon(holon_string);
    //   emit holonLoaded(path);
    //});
}

void H4msPersistenceProvider::loadNamespace(QString path) {
    QtConcurrent::run(
        [path, this] () mutable {
            qDebug() << "Loading namespace" << path;
            std::future<QString> f = m_namespace_connector.get(path);
            QString hash = f.get();
            qDebug() << "Got hash" << hash << "for namespace" << path;
            QString holon_text = m_holon_storage.get(hash).get();
            qDebug() << "Got holon content" << holon_text << "for hash" << hash;
            Holon* holon = new Holon(holon_text);
            m_holons[path] = holon;
            NamespaceMeta meta;
            meta.hash = hash;
            meta.holon = holon;
            m_namespace_metas[path] = meta;
        }
    );
}

void H4msPersistenceProvider::initNamespace(QString path, QString namespace_holon_content) {
    QtConcurrent::run(
        [=] () mutable {
            qDebug() << "Putting namespace holon to storage:" << namespace_holon_content;
            QString hash = m_holon_storage.put(namespace_holon_content);
            qDebug() << "Got hash:" << hash;
            qDebug() << "Putting that for" << path << "into namespace registrar";
            std::future<bool> putFuture = m_namespace_connector.put(path, hash);
            qDebug() << "success:" << putFuture.get();
        }
    );
}

void H4msPersistenceProvider::commitHolon(QString path, Holon* holon) {

}


QString H4msPersistenceProvider::findNamespaceByPath(QString path) {
    foreach(QString namespace_name, m_namespace_metas.keys()) {
        if(path.startsWith(namespace_name)) return namespace_name;
    }
    QStringList path_list = path.split("/");
    while(path_list.length() > 2) path_list.pop_back();
    return QString("/%1").arg(path_list.join("/"));
}
