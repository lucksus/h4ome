{
  // Every holon has a name for user interaction.
  // This is not its address which is its IPFS hash.
  _holon_name: "Nico's Example Holon",

  // Holons are immutable, so no 'last modified', but creation date
  _holon_created: "20160719_0413",

  // If this holon was created as the new state of a pre-existing holon
  // this field holds the address (IPFS hash) of the preceding state
  // of this holon. So this is the next state within the un-do list.
  _holon_precursor: "Qjao39dser3",

  // _holon_nodes and _holon_edges are the Nodesphere parts of a holon.
  // Also, if this holon is a directory _holon_nodes lists the H4OME paths
  // of its contents. If it is a namespace holon these references point to
  // IPFS hashes, as in this example.
  _holon_nodes: {
    "intention1": "Qmasdnlwsakdnt32",
    "vision1": "Qmasdinwlijsa"
  }

  _holon_edges: [
    {
      // 'parentOf' edges don't necessarily need a source field,
      // it defaults to this holon.
      type: "parentOf",
      destination: "intention1"
    },
    {
      type: "parentOf",
      destination: "vision1"
    },
    {
      type: "parentOf",
      destination: "vision1"
    },
    {
      type: "implements",
      source: "intention1",
      destination: "vision1"
    }
  ]

  // Holon subjects are links to other holons which are not yet resolved
  // but are already named and potentially used within this holon.
  // The surrounding context(s) (=holons) will set a specific other holon
  // by adding a (horizontal) link from this holon to the other holon with the
  // same type and/or name as the holon subject defined here.
  //
  // So, a holon subject is a subjective view of any other holon from this holon.
  // In Holon Oriented Programming (HOOP), other parts of a complex system (system
  // constituted of more than one holon) are defined here and thus represented
  // by a logical proxy that can be thought of the subjective projection
  // as in the model of this holon for/on the other holon.
  //
  // A subject is an interface to the outside world.
  // It will appear as a slot (to be filled) alongside this holon
  // in any encompassing context and it will appear speacially marked
  // holon within this holon.
  _holon_subjects: [
    {
      // Name of this subject
      name: 'vision to implement',

      // The type of the referenced holon (optional)
      type: 'vision',

      // The type of the edge within the surrounding context that connects
      // this to the other holon. (optional)
      edge_type: 'implements',

      // Fixed quantity of other holons referenced by this subject
      // (optional)
      // (defaults to 1)
      quantity: 1,

      // Is this holon only functional with this subject set?
      required: false
    }
  ]


}
