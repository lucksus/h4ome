#ifndef HOLONSTORAGE_H
#define HOLONSTORAGE_H

#include <QObject>
#include <QFuture>
#include <QNetworkAccessManager>
#include <QHash>

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
    Q_PROPERTY(bool uploading READ uploading WRITE setUploading NOTIFY uploadingChanged)
    Q_PROPERTY(bool downloading READ downloading WRITE setDownloading NOTIFY downloadingChanged)
    Q_PROPERTY(double progress_up READ progress_up WRITE setProgress_up NOTIFY progress_upChanged)
    Q_PROPERTY(double progress_down READ progress_down WRITE setProgress_down NOTIFY progress_downChanged)
    Q_PROPERTY(bool networkAccessible READ networkAccessible WRITE setNetworkAccessible NOTIFY networkAccessibleChanged)

public:
    HolonStorage(QString root_path);

    bool uploading() const;
    void setUploading(bool);
    bool downloading() const;
    void setDownloading(bool);
    double progress_up() const;
    void setProgress_up(double);
    double progress_down() const;
    void setProgress_down(double);
    bool networkAccessible() const;
    void setNetworkAccessible(bool);

signals:
    void uploadingChanged();
    void downloadingChanged();
    void progress_upChanged();
    void progress_downChanged();
    void networkAccessibleChanged();

public slots:
    //! Gets holon contents for given IPFS hash.
    //! Wait still contents are available.
    QString get_sync(QString hash);

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
    QNetworkAccessManager m_network_manager;
    QHash<QString, QNetworkReply*> m_uploads;
    QHash<QString, QNetworkReply*> m_downloads;
    QHash<QString, QString> m_last_sync;
    QHash<QNetworkReply*, QString> m_hash;

    void sync(QString holon);
    void download(QString hash);

    bool isUploading(QString hash) const;
    bool isDownloading(QString hash) const;
    bool isSynced(QString hash) const;

    void write_file(QString filename, QString holon);

private slots:
    void request_finished(QNetworkReply*);
};

//qmlRegisterType<HolonStorage>("com.h4ome.holon_storage", 0, 1, "HolonStorage");

#endif // HOLONSTORAGE_H
