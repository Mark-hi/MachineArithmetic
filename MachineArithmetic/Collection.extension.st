Extension { #name : #Collection }

{ #category : #'*MachineArithmetic' }
Collection >> inEnvironment: env [
	^self collect: [ :anElement | anElement inEnvironment: env ]
]

{ #category : #'*MachineArithmetic' }
Collection >> selectAssuming: prereq in: aSolver [
	"Collect into a new collection like the receiver, only those elements for which aBlock evaluates to true. Answer the new collection."
	^aSolver bracket: [
		aSolver assert: prereq.
		self select: [ :element | aSolver bracket: [ 
				aSolver isValid: element ]]
	]
]

{ #category : #'*MachineArithmetic' }
Collection >> withoutNils [
	^self reject: [ :x | x isNil ]
]
