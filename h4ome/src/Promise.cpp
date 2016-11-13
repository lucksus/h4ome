// -*- mode: C++; tab-width: 2; indent-tabs-mode: nil; coding: unix -*-

#include <QQmlEngine>

#include "Promise.h"

QQmlEngine* Promise::mEngine = nullptr;

Promise::Promise(QObject *parent) :
QObject(parent),
mState(State::PENDING)
{
    mArguments = new std::initializer_list<QVariant>;
}

Promise::Promise(const Promise& p) :
    QObject(p.parent()),
    mState(p.mState),
    mOnResolve(p.mOnResolve),
    mOnReject(p.mOnReject),
    mArguments(p.mArguments)
{
}

Promise::~Promise(){
    delete mArguments;
}

void Promise::setEngine(QQmlEngine* engine)
{
  mEngine = engine;
}

void Promise::then(QJSValue onResolve, QJSValue onReject)
{
 mOnResolve = onResolve;
 mOnReject = onReject;
 if(isSettled()) {
     if(mState == State::FULFILLED) complete(mOnResolve, result);
     if(mState == State::REJECTED) complete(mOnReject, result);
 }
}

void Promise::resolve(const std::initializer_list<QVariant> &arguments)
{
  if (!isSettled()) {
    mState = State::FULFILLED;
    *mArguments = arguments;
    complete(mOnResolve, arguments);
  }
}

void Promise::resolve(QString string) {
    if (!isSettled()) {
      mState = State::FULFILLED;
      result = string;
      complete(mOnResolve, result);
    }
}

void Promise::reject(const std::initializer_list<QVariant> &arguments)
{
  if (!isSettled()) {
    mState = State::REJECTED;
    complete(mOnReject, arguments);
  }
}

bool Promise::isSettled() const
{
  return mState == State::PENDING ? false: true;
}


void Promise::complete(QJSValue fn, const std::initializer_list<QVariant> &arguments)
{
  QJSValueList list;
  for (const QVariant &item : arguments) {
      QString string = item.toString();
      list << mEngine->toScriptValue(string);
  }

  if (fn.isCallable()) {
    fn.call(list);
  }
}

void Promise::complete(QJSValue fn, QString result)
{
  QJSValueList list;
  list << result;

  if (fn.isCallable()) {
    fn.call(list);
  }
}
