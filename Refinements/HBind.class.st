Class {
	#name : #HBind,
	#superclass : #Object,
	#instVars : [
		'x',
		'τ',
		'p'
	],
	#category : #Refinements
}

{ #category : #naming }
HBind class >> dummy [
	^self x: self dummyName τ: Int sort p: (HPredAnd of: #())
]

{ #category : #naming }
HBind class >> dummyName [
	^'LIQUIDßdummy'
]

{ #category : #'instance creation' }
HBind class >> x: x τ: τ p: p [
	^self basicNew 
		x: x;
		τ: τ;
		p: p;
		yourself 
]

{ #category : #accessing }
HBind >> p [
	^ p
]

{ #category : #accessing }
HBind >> p: anObject [
	p := anObject
]

{ #category : #printing }
HBind >> printOn: aStream [
	aStream nextPutAll: self x.
	aStream nextPutAll: ':'.
	τ printOn: aStream.
	aStream nextPutAll: ' | '.
	self p printOn: aStream
]

{ #category : #'as yet unclassified' }
HBind >> uBind: α [
	| x_ p_ |
	x_ := α uVariable: x.
	p_ := α rename: p.
	^HBind x: x_ τ: τ p: p_
]

{ #category : #accessing }
HBind >> x [
	^ x
]

{ #category : #accessing }
HBind >> x: anObject [
	x := anObject
]

{ #category : #accessing }
HBind >> τ [
	^ τ
]

{ #category : #accessing }
HBind >> τ: anObject [
	τ := anObject
]
