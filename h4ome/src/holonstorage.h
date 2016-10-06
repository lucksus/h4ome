#ifndef HOLONSTORAGE_H
#define HOLONSTORAGE_H

#include <QObject>
#include <QFuture>

//! HolonStorage handles all the things for you.
//! Just put in a holon (which returns its address==hash)
//! and get (get_sync) it back by providing its hash.
//!
//! This class builds an abstraction layer over IPFS.
//! In this first implementation, holons are just stored
//! as files within the local filesystem - nothing else.
class HolonStorage : public QObject
{
    Q_OBJECT
public:
    HolonStorage(QString root_path);

signals:

public slots:
    //! Gets holon contents for given IPFS hash.
    //! Wait still contents are available.
    QString get_sync(QString hash) const;

    //! Gets holon contents for given IPFS hash.
    //! Returns immediately and return future object.
    //QFuture get(QString hash) const;

    //! Saves holon
    //! Returns its hash (=address)
    QString put(QString holon);

    //! Calculcate the given holon's IPFS hash
    QString hash(QString holon) const;

private:
    QString m_root_path;
    QString file_path(QString holon) const;
};

//qmlRegisterType<HolonStorage>("com.h4ome.holon_storage", 0, 1, "HolonStorage");

#endif // HOLONSTORAGE_H
