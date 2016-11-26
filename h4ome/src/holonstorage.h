#ifndef HOLONSTORAGE_H
#define HOLONSTORAGE_H

#include <QObject>
#include <QFuture>
#include <QNetworkAccessManager>
#include <QHash>

class Promise;

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

    //! Gets holon contents for given IPFS hash.
    //! Returns a promise that will resolve with the holon's content as a string
    Q_INVOKABLE QObject* get(QString hash);

    //! Saves holon
    //! Returns its hash (=address)
    Q_INVOKABLE QString put(QString holon);

    //! Calculcate the given holon's IPFS hash
    Q_INVOKABLE QString hash(QString holon) const;


signals:
    void uploadingChanged();
    void downloadingChanged();
    void progress_upChanged();
    void progress_downChanged();
    void networkAccessibleChanged();

    void holonDownloaded(QString hash);

private:
    QString m_root_path;
    QString file_path(QString holon) const;
    QNetworkAccessManager m_network_manager;
    QHash<QString, QNetworkReply*> m_uploads;
    QHash<QString, QNetworkReply*> m_downloads;
    QHash<QString, QString> m_last_sync;
    QHash<QNetworkReply*, QString> m_hash;
    QHash<QString, Promise*> m_download_promises;
    QHash<QNetworkReply*, qint64> m_bytes_transfered;
    QHash<QNetworkReply*, qint64> m_bytes_total;

    void sync(QString holon);
    void download(QString hash, Promise* promise);

    bool isUploading(QString hash) const;
    bool isDownloading(QString hash) const;
    bool isSynced(QString hash) const;

    void write_file(QString filename, QString holon);

private slots:
    void handleFinishedDownload();
    void handleFinishedUpload();
    void transferProgress(qint64 bytesReceived, qint64 bytesTotal);
    void writeSyncTable();
    void loadSyncTable();
};

//qmlRegisterType<HolonStorage>("com.h4ome.holon_storage", 0, 1, "HolonStorage");

#endif // HOLONSTORAGE_H
