{
  // ... every holon attribute ... (see holon_spec.js and all other *_holon_spec.js)

  // Function to be run when this holon is 'activated' which is either triggered
  // by the user doubleclicking on this holon or by code within another holon
  // calling this holon or sending a holon to this:
  //
  // _holon.subjects.greeter.call()
  // _holon.subjects.greeter.send()
  _active_holon_function: "_holon.greet()", //calls slot defined below

  // Programming language used in function
  _active_holon_lang: 'ES6',

  // List of signals
  // Signals can be triggered from within this holon - they are available as
  // function within the script context of this holon ('greet' slot, l. 32).
  _active_holon_signals: [
    {
      name: 'greeted',
      params: []
    }
  ],

  // List of slots
  // Slots are named (member) functions of this holon which can be connected
  // to signals of this or other holons.
  _active_holon_slots: [
    {
      name: 'greet',
      lang: 'ES6',
      code: "_holon.log('Hello Holon'); _holon.greeted()"
    }
  ]
}
