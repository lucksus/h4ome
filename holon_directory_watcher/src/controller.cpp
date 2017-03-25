#include "controller.h"
#include <iostream>
using namespace std;

Controller::Controller()
{

}

Controller& Controller::getInstance() {
    static Controller c;
    return c;
}


void Controller::loggedIn()
{
    //m_persistance->loadHolon(m_root_path);
}

void Controller::logInError(QString error)
{
    cout << "Error while trying to login at h4ms: " << error.toStdString() << endl;
    exit(1);
}
