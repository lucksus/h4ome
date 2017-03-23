#ifndef ENVIRONMENT_H
#define ENVIRONMENT_H
#include <QString>

class Holon;
class MutableHolon;
class HolonRunTime;

class Environment
{
public:
    Environment();

private:
    MutableHolon *m_locus;
    Holon *m_interface;
    HolonRunTime *m_interface_runtime;
};

#endif // ENVIRONMENT_H
