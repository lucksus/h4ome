#include "controller.h"
#include <iostream>
#include <QCoreApplication>
#include <QCommandLineParser>
#include <QFile>

using namespace std;

Controller::Controller()
{
    m_persistance = new H4msPersistenceProvider;

}

void Controller::setRootPath(QString path) {
    m_root_path = path;
}


Controller& Controller::getInstance() {
    static Controller c;
    return c;
}

void Controller::setInitFile(QString file) {
    m_init_file = file;
}

void Controller::handleCommandlineArguments() {
    if (m_init_file != "") {
        QFile init_file(m_init_file);
        if (init_file.open(QFile::ReadOnly)) {
            QTextStream in (&init_file);
            QString holon = in.readAll();
            m_persistance->initNamespace(m_root_path, holon);
        } else {
            qFatal( QString("Could not read file %1!").arg(m_init_file ).toLocal8Bit() );
        }
    }
}

void Controller::loggedIn()
{
    //m_persistance->loadNamespace("/home/lucksus");
    handleCommandlineArguments();
}

void Controller::logInError(QString error)
{
    cout << "Error while trying to login at h4ms: " << error.toStdString() << endl;
    QCoreApplication::quit();
}
