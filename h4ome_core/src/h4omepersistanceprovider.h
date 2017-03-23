#ifndef H4OMEPERSISTANCEPROVIDER_H
#define H4OMEPERSISTANCEPROVIDER_H
#include <QObject>
#include <QStringList>

class Holon;
class H4OMEPersistanceProvider : public QObject {
    Q_OBJECT
    //Q_PROPERTY(QStringList loadedHolons READ loadedHolons NOTIFY loadedHolonsChanged())

public:
    virtual Holon* getHolon(QString path) = 0;
    virtual void loadHolon(QString path) = 0;
    virtual void commitHolon(QString path, Holon* holon) = 0;

};


#endif // H4OMEPERSISTANCEPROVIDER_H
