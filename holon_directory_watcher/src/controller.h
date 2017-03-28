#ifndef CONTROLLER_H
#define CONTROLLER_H

#include <QObject>
#include "h4mspersistenceprovider.h"

class Controller : public QObject
{
Q_OBJECT

public:
    static Controller& getInstance();
    void setRootPath(QString path);
    void setInitFile(QString file);

public slots:
    void loggedIn();
    void logInError(QString);
    void handleCommandlineArguments();

signals:


private:
    Controller();
    H4msPersistenceProvider *m_persistance;
    QString m_root_path;
    QString m_init_file;

};

#endif // CONTROLLER_H
