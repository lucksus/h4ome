#include <QtGui/QGuiApplication>
#include <QtCore/QDir>
#include <QtQuick/QQuickView>
#include <QtQml/QQmlApplicationEngine>
#include <QQuickStyle>
#include <QSettings>

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

    QQmlApplicationEngine engine;
    engine.load(QUrl("qrc:/h4ome.qml"));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
