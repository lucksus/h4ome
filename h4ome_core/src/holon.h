#ifndef HOLON_H
#define HOLON_H
#include <QObject>
#include <QString>
#include <QJsonObject>

class Holon : public QObject {
    Q_OBJECT

public:
    Holon(QString source);
    Holon(const Holon &h);
    QJsonValue getProperty(QString property_name) const;
    void setProperty(QString property_name, QJsonValue value);
    bool isAltered() const;

private:
    QString m_source;
    QJsonObject m_json;
};

#endif // HOLON_H
