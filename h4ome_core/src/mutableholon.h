#ifndef MUTABLEHOLON_H
#define MUTABLEHOLON_H
#include "holon.h"

class MutableHolon : public Holon
{
public:
    MutableHolon(QString content, QString path);

private:
    QString m_path;
};

#endif // MUTABLEHOLON_H
