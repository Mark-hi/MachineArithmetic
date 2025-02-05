Class {
	#name : #L1ExpressionParserTest,
	#superclass : #TestCaseWithZ3Context,
	#category : #'SpriteLang-Tests-Parser'
}

{ #category : #tests }
L1ExpressionParserTest >> test42expr [
	| e |
	e := (ΛκParser new productionAt: #expr) end parse: '42'.
	self assert: e imm prim integer equals: 42
]

{ #category : #tests }
L1ExpressionParserTest >> testAnnotationBrackets [
	| ast |
	ast := 'asdf' asParser flatten annotationBrackets end parse: '⟦asdf⟧'.
	self assert: ast equals: 'asdf'

]

{ #category : #tests }
L1ExpressionParserTest >> testAplusB [
	| e |
	e := (ΛκParser new productionAt: #expr) end parse: 'a + b'.
	self assert: e imm symbol equals: 'b'
]

{ #category : #tests }
L1ExpressionParserTest >> testAppExpr [
	| f |
	f := (ΛκParser new productionAt: #appExpr) parse: 'f(x,y,z)'.
	self assert: f imm symbol equals: 'z'
]

{ #category : #tests }
L1ExpressionParserTest >> testBinExpr [
	| e |
	e := (ΛκParser new productionAt: #binExpr) end parse: 'x >= 0'.
	self assert: (e expr isKindOf: EApp).
	self assert: (e imm  isKindOf: ECon).
]

{ #category : #tests }
L1ExpressionParserTest >> testBinder [
	| b |
	b := (ΛκParser new productionAt: #binder) end parse: 'x'.
	self assert: b id equals: 'x'
]

{ #category : #tests }
L1ExpressionParserTest >> testFun [
	| f |
	f := (ΛκParser new productionAt: #funExpr) parse: '(x) => { x + 1 }'.
	self assert: f bind id equals: 'x'
]

{ #category : #tests }
L1ExpressionParserTest >> testLet [
	| f |
	f := (ΛκParser new productionAt: #letExpr) parse: 'let tmp = inc(x); inc(tmp)'.
	self assert: (f isKindOf: ELet)
]

{ #category : #tests }
L1ExpressionParserTest >> testOpLe [
	| e |
	e := ΛPrimOp parser end parse: '<='.
	self assert: e class equals: BLe
]

{ #category : #tests }
L1ExpressionParserTest >> testOpLt [
	| e |
	e := ΛPrimOp parser end parse: '<'.
	self assert: e class equals: BLt
]

{ #category : #tests }
L1ExpressionParserTest >> testPlainDecl [
	| f |
	f := (ΛκParser new productionAt: #plainDecl) end parse: 'let inc = (x) => { x + 1 };'.
	self assert: (f isKindOf: SpriteDecl)
]

{ #category : #tests }
L1ExpressionParserTest >> testXexpr [
	| e |
	e := (ΛκParser new productionAt: #expr) end parse: 'x'.
	self assert: e imm symbol equals: 'x'
]
