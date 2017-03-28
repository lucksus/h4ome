#include <QCoreApplication>
#include <QCommandLineParser>
#include <iostream>
#include <string>
#include <termios.h>
#include <unistd.h>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QNetworkAccessManager>
#include <QJsonObject>
#include <QJsonDocument>
#include "api_constants.h"
#include "h4mssessionmanager.h"
#include "controller.h"

using namespace std;

QString getPassword(QString prompt) {
    termios oldt;
    tcgetattr(STDIN_FILENO, &oldt);
    termios newt = oldt;
    newt.c_lflag &= ~ECHO;
    tcsetattr(STDIN_FILENO, TCSANOW, &newt);
    string s;
    cout << prompt.toStdString();
    getline(cin, s);
    cout << endl;
    newt.c_lflag |= ECHO;
    tcsetattr(STDIN_FILENO, TCSANOW, &newt);
    return s.c_str();
}


int main(int argc, char *argv[])
{
    QCoreApplication app(argc, argv);
    QCoreApplication::setApplicationName("H4OME Holon Directory Watcher");
    QCoreApplication::setApplicationVersion("0.1");

    QCommandLineParser parser;
    parser.setApplicationDescription(QCoreApplication::translate("main", "Syncs a given directory of the local filesystem with a given H4OME namespace"));
    parser.addHelpOption();
    parser.addVersionOption();
    parser.addPositionalArgument("username", QCoreApplication::translate("main", "H4OME username (e.g. lucksus)"));
    parser.addPositionalArgument("h4ome-namespace", QCoreApplication::translate("main", "H4OME namespace to sync with (e.g. /home/lucksus)"));
    parser.addPositionalArgument("directory", QCoreApplication::translate("main", "Directory to watch for changes and hold local copy of holons in namespace"));

    // A boolean option with multiple names (-v, --verbose)
    QCommandLineOption verboseOption(QStringList() << "v" << "verbose",
            QCoreApplication::translate("main", "Show more (debugging) output"));
    parser.addOption(verboseOption);

    QCommandLineOption initFileOption(QStringList() << "f" << "initialise-with-file",
            QCoreApplication::translate("main", "Initialises the namespace with the given file which will be uploaded and it's hash registered for the given namespace"),
            QCoreApplication::translate("main", "namespace holon file"));
    parser.addOption(initFileOption);

    // Process the actual command line arguments given by the user
    parser.process(app);

    const QStringList args = parser.positionalArguments();
    if(args.length() != 3) parser.showHelp();

    const QString username = args.at(0);
    const QString h4ome_namespace = args.at(1);
    const QString directory = args.at(2);

    bool verbose = parser.isSet(verboseOption);

    QString password = getPassword(QString("Please enter password for user '%1': ").arg(username));

    QObject::connect(&H4msSessionManager::getInstance(), &H4msSessionManager::loggedIn, &Controller::getInstance(), &Controller::loggedIn);
    QObject::connect(&H4msSessionManager::getInstance(), &H4msSessionManager::error, &Controller::getInstance(), &Controller::logInError);
    H4msSessionManager::getInstance().login(username, password);

    Controller::getInstance().setRootPath(h4ome_namespace);

    if(parser.isSet(initFileOption)){
        QString initFile = parser.value(initFileOption);
        Controller::getInstance().setInitFile(initFile);
    }

    return app.exec();

}
