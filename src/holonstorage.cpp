#include "holonstorage.h"
#include <QCryptographicHash>
#include <QFile>
#include <QDir>

HolonStorage::HolonStorage(QString root_path) :
    QObject(0), m_root_path(root_path)
{
    QDir dir;
    dir.mkpath(root_path);
}

QString HolonStorage::get_sync(QString hash) const {
    QFile data(file_path(hash));
    QString holon;
    if (data.open(QFile::ReadOnly) ) {
        QTextStream in (&data);
        holon = in.readAll();
    }
    return holon;
}

QString HolonStorage::put(QString holon) {
    QString holon_hash = hash(holon);
    QFile data(file_path(holon_hash));
    if (data.open(QFile::WriteOnly | QFile::Truncate)) {
        QTextStream out(&data);
        out << holon;
    }
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

