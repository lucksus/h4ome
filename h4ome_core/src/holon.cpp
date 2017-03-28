#include "holon.h"
#include <QJsonDocument>
#include <QVariant>

Holon::Holon(QString source) {
    m_source = source;
    m_json = QJsonDocument::fromJson(source.toLocal8Bit()).object();
}


Holon::Holon(const Holon &h) :
    m_source(h.m_source),
    m_json(h.m_json)
{

}

QJsonValue Holon::getProperty(QString property_name) const {

}

void Holon::setProperty(QString property_name, QJsonValue value) {

}

bool Holon::isAltered() const {
    //return m_json != QJsonDocument::fromJson(m_source.toLocal8Bit());
}

QHash<QString, QVariant> Holon::getNodes() {
    m_json["_holon_nodes"].toObject().toVariantHash();
}

QString Holon::getSubnodeHash(QString name) {
    return getNodes()[name].toString();
}
