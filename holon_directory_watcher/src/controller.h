#ifndef CONTROLLER_H
#define CONTROLLER_H

#include <QObject>
#include "h4omepersistanceprovider.h"

class Controller : public QObject
{
Q_OBJECT

public:
    static Controller& getInstance();
    void setRootPath(QString path);

public slots:
    void loggedIn();
    void logInError(QString);

signals:


private:
    Controller();
    H4OMEPersistanceProvider *m_persistance;
    QString m_root_path;

};

#endif // CONTROLLER_H
