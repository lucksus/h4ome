#ifndef H4MSPERSISTENCEPROVIDER_H
#define H4MSPERSISTENCEPROVIDER_H
#include "h4omepersistanceprovider.h"
#include <QHash>
#include "holonstorage.h"
#include "h4msnamespaceconnector.h"

struct NamespaceMeta {
    QString hash;
    QString type;
    bool writable;
    bool isSyncing;
    unsigned int lastSynced;
    Holon* holon;
};

class H4msPersistenceProvider : public H4OMEPersistanceProvider
{
public:
    H4msPersistenceProvider();

    virtual Holon* getHolon(QString path);
    virtual void loadHolon(QString path);
    virtual void commitHolon(QString path, Holon* holon);

    void loadNamespace(QString path);
    void initNamespace(QString path, QString namespace_holon_content);

private:
    QHash<QString, NamespaceMeta> m_namespace_metas;
    QHash<QString, Holon*> m_holons;

    QString findNamespaceByPath(QString path);

    HolonStorage m_holon_storage;
    H4msNamespaceConnector m_namespace_connector;
};

#endif // H4MSPERSISTENCEPROVIDER_H
