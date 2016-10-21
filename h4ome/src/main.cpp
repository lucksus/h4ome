#include <QtGui/QGuiApplication>
#include <QtCore/QDir>
#include <QtQuick/QQuickView>
#include <QtQml/QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickStyle>
#include <QSettings>
#include <QFile>
#include "holonstorage.h"

int main(int argc, char *argv[])
{

    QGuiApplication::setApplicationName("H4OME");
    QGuiApplication::setOrganizationName("S7 Foundation");
    QGuiApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    QSettings settings;
    QString style = QQuickStyle::name();
    if (!style.isEmpty())
        settings.setValue("style", style);
    else
        QQuickStyle::setStyle(settings.value("style").toString());

    QString storage_dir = QString("%1/holon_storage").arg(app.applicationDirPath());
    HolonStorage holon_storage(storage_dir);

    QString namespace_seeds;
    QFile namespace_seeds_file(":/seeds/namespaces.js");
    if (namespace_seeds_file.open(QFile::ReadOnly) ) {
        QTextStream in (&namespace_seeds_file);
        namespace_seeds = in.readAll();
    }

    QQmlApplicationEngine engine;
    //engine.rootContext()->setContextProperty(QString("API_BASE_URL"), QString("https://h4ms.rosental10.de/api/v1/"));
    engine.rootContext()->setContextProperty(QString("API_BASE_URL"), QString("http://localhost:3000/api/v1/"));
    engine.rootContext()->setContextProperty(QString("HolonStorage"), &holon_storage);
    engine.rootContext()->setContextProperty(QString("NAMESPACE_SEEDS"), namespace_seeds);
    engine.load(QUrl("qrc:/h4ome.qml"));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
