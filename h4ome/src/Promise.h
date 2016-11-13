// -*- mode: C++; tab-width: 2; indent-tabs-mode: nil; coding: unix -*-

#pragma once

#include <initializer_list>
#include <QJSValue>
#include <QObject>
#include <QVariant>

class QQmlEngine;

class Promise : public QObject
{
  Q_OBJECT
public:
  enum class State {
    PENDING,
    FULFILLED,
    REJECTED
  };

  explicit Promise(QObject *parent = 0);
  Promise(const Promise&);
  ~Promise();
  static void setEngine(QQmlEngine* engine);
  Q_INVOKABLE void then(QJSValue onResolve, QJSValue onReject = QJSValue());
  void resolve(const std::initializer_list<QVariant> &arguments);
  void resolve(QString);
  void reject(const std::initializer_list<QVariant> &arguments);
protected:
  void complete(QJSValue fn, const std::initializer_list<QVariant> &arguments);
  void complete(QJSValue fn, QString);
  bool isSettled() const;
private:
  static QQmlEngine* mEngine;
  State mState;
  QJSValue mOnResolve;
  QJSValue mOnReject;
  std::initializer_list<QVariant>* mArguments;
  QString result;
};

Q_DECLARE_METATYPE(Promise);
