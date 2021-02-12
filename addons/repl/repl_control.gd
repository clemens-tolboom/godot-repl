# REPL editor control
# Copyright (C) 2021  Sylvain Beucler

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.

# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

extends Control
tool

onready var input = find_node('input')
onready var output = find_node('output')

var hist = [''];
var hist_index = 0;

# Import built-in classes
# ClassDB.get_class_list() + fix compile/runtime errors (Godot 3.2.3)
# (this crashes and is incorrect:)
#for name in ClassDB.get_class_list():
#	variables[name] = ClassDB.instance(name)
# Use load() for GDScript classes
#var variables = {'ClassDB': ClassDB}  # for updating below
var variables = {
	'ARVRAnchor': ARVRAnchor,
	'ARVRCamera': ARVRCamera,
	'ARVRController': ARVRController,
	'ARVRInterface': ARVRInterface,
	'ARVRInterfaceGDNative': ARVRInterfaceGDNative,
	'ARVROrigin': ARVROrigin,
	'ARVRPositionalTracker': ARVRPositionalTracker,
	'ARVRServer': ARVRServer,
	'AStar': AStar,
	'AStar2D': AStar2D,
	'AcceptDialog': AcceptDialog,
	'AnimatedSprite': AnimatedSprite,
	'AnimatedSprite3D': AnimatedSprite3D,
	'AnimatedTexture': AnimatedTexture,
	'Animation': Animation,
	'AnimationNode': AnimationNode,
	'AnimationNodeAdd2': AnimationNodeAdd2,
	'AnimationNodeAdd3': AnimationNodeAdd3,
	'AnimationNodeAnimation': AnimationNodeAnimation,
	'AnimationNodeBlend2': AnimationNodeBlend2,
	'AnimationNodeBlend3': AnimationNodeBlend3,
	'AnimationNodeBlendSpace1D': AnimationNodeBlendSpace1D,
	'AnimationNodeBlendSpace2D': AnimationNodeBlendSpace2D,
	'AnimationNodeBlendTree': AnimationNodeBlendTree,
	'AnimationNodeOneShot': AnimationNodeOneShot,
	'AnimationNodeOutput': AnimationNodeOutput,
	'AnimationNodeStateMachine': AnimationNodeStateMachine,
	'AnimationNodeStateMachinePlayback': AnimationNodeStateMachinePlayback,
	'AnimationNodeStateMachineTransition': AnimationNodeStateMachineTransition,
	'AnimationNodeTimeScale': AnimationNodeTimeScale,
	'AnimationNodeTimeSeek': AnimationNodeTimeSeek,
	'AnimationNodeTransition': AnimationNodeTransition,
	'AnimationPlayer': AnimationPlayer,
	'AnimationRootNode': AnimationRootNode,
	'AnimationTrackEditPlugin': AnimationTrackEditPlugin,
	'AnimationTree': AnimationTree,
	'AnimationTreePlayer': AnimationTreePlayer,
	'Area': Area,
	'Area2D': Area2D,
	'ArrayMesh': ArrayMesh,
	'AtlasTexture': AtlasTexture,
	'AudioBusLayout': AudioBusLayout,
	'AudioEffect': AudioEffect,
	'AudioEffectAmplify': AudioEffectAmplify,
	'AudioEffectBandLimitFilter': AudioEffectBandLimitFilter,
	'AudioEffectBandPassFilter': AudioEffectBandPassFilter,
	'AudioEffectChorus': AudioEffectChorus,
	'AudioEffectCompressor': AudioEffectCompressor,
	'AudioEffectDelay': AudioEffectDelay,
	'AudioEffectDistortion': AudioEffectDistortion,
	'AudioEffectEQ': AudioEffectEQ,
	'AudioEffectEQ10': AudioEffectEQ10,
	'AudioEffectEQ21': AudioEffectEQ21,
	'AudioEffectEQ6': AudioEffectEQ6,
	'AudioEffectFilter': AudioEffectFilter,
	'AudioEffectHighPassFilter': AudioEffectHighPassFilter,
	'AudioEffectHighShelfFilter': AudioEffectHighShelfFilter,
	'AudioEffectInstance': AudioEffectInstance,
	'AudioEffectLimiter': AudioEffectLimiter,
	'AudioEffectLowPassFilter': AudioEffectLowPassFilter,
	'AudioEffectLowShelfFilter': AudioEffectLowShelfFilter,
	'AudioEffectNotchFilter': AudioEffectNotchFilter,
	'AudioEffectPanner': AudioEffectPanner,
	'AudioEffectPhaser': AudioEffectPhaser,
	'AudioEffectPitchShift': AudioEffectPitchShift,
	'AudioEffectRecord': AudioEffectRecord,
	'AudioEffectReverb': AudioEffectReverb,
	'AudioEffectSpectrumAnalyzer': AudioEffectSpectrumAnalyzer,
	'AudioEffectSpectrumAnalyzerInstance': AudioEffectSpectrumAnalyzerInstance,
	'AudioEffectStereoEnhance': AudioEffectStereoEnhance,
	'AudioServer': AudioServer,
	'AudioStream': AudioStream,
	'AudioStreamGenerator': AudioStreamGenerator,
	'AudioStreamGeneratorPlayback': AudioStreamGeneratorPlayback,
	'AudioStreamMicrophone': AudioStreamMicrophone,
	'AudioStreamOGGVorbis': AudioStreamOGGVorbis,
	'AudioStreamPlayback': AudioStreamPlayback,
	'AudioStreamPlaybackResampled': AudioStreamPlaybackResampled,
	'AudioStreamPlayer': AudioStreamPlayer,
	'AudioStreamPlayer2D': AudioStreamPlayer2D,
	'AudioStreamPlayer3D': AudioStreamPlayer3D,
	'AudioStreamRandomPitch': AudioStreamRandomPitch,
	'AudioStreamSample': AudioStreamSample,
	'BackBufferCopy': BackBufferCopy,
	'BakedLightmap': BakedLightmap,
	'BakedLightmapData': BakedLightmapData,
	'BaseButton': BaseButton,
	'BitMap': BitMap,
	'BitmapFont': BitmapFont,
	'Bone2D': Bone2D,
	'BoneAttachment': BoneAttachment,
	'BoxContainer': BoxContainer,
	'BoxShape': BoxShape,
	'BulletPhysicsDirectBodyState': BulletPhysicsDirectBodyState,
	#'BulletPhysicsDirectSpaceState': BulletPhysicsDirectSpaceState,
	'BulletPhysicsServer': BulletPhysicsServer,
	'Button': Button,
	'ButtonGroup': ButtonGroup,
	'CPUParticles': CPUParticles,
	'CPUParticles2D': CPUParticles2D,
	'CSGBox': CSGBox,
	'CSGCombiner': CSGCombiner,
	'CSGCylinder': CSGCylinder,
	'CSGMesh': CSGMesh,
	'CSGPolygon': CSGPolygon,
	'CSGPrimitive': CSGPrimitive,
	'CSGShape': CSGShape,
	'CSGSphere': CSGSphere,
	'CSGTorus': CSGTorus,
	'Camera': Camera,
	'Camera2D': Camera2D,
	'CameraFeed': CameraFeed,
	'CameraServer': CameraServer,
	'CameraTexture': CameraTexture,
	'CanvasItem': CanvasItem,
	'CanvasItemMaterial': CanvasItemMaterial,
	'CanvasLayer': CanvasLayer,
	'CanvasModulate': CanvasModulate,
	'CapsuleMesh': CapsuleMesh,
	'CapsuleShape': CapsuleShape,
	'CapsuleShape2D': CapsuleShape2D,
	'CenterContainer': CenterContainer,
	'CharFXTransform': CharFXTransform,
	'CheckBox': CheckBox,
	'CheckButton': CheckButton,
	'CircleShape2D': CircleShape2D,
	'ClippedCamera': ClippedCamera,
	'CollisionObject': CollisionObject,
	'CollisionObject2D': CollisionObject2D,
	'CollisionPolygon': CollisionPolygon,
	'CollisionPolygon2D': CollisionPolygon2D,
	'CollisionShape': CollisionShape,
	'CollisionShape2D': CollisionShape2D,
	'ColorPicker': ColorPicker,
	'ColorPickerButton': ColorPickerButton,
	'ColorRect': ColorRect,
	'ConcavePolygonShape': ConcavePolygonShape,
	'ConcavePolygonShape2D': ConcavePolygonShape2D,
	'ConeTwistJoint': ConeTwistJoint,
	'ConfigFile': ConfigFile,
	'ConfirmationDialog': ConfirmationDialog,
	'Container': Container,
	'Control': Control,
	'ConvexPolygonShape': ConvexPolygonShape,
	'ConvexPolygonShape2D': ConvexPolygonShape2D,
	'Crypto': Crypto,
	'CryptoKey': CryptoKey,
	'CubeMap': CubeMap,
	'CubeMesh': CubeMesh,
	'Curve': Curve,
	'Curve2D': Curve2D,
	'Curve3D': Curve3D,
	'CurveTexture': CurveTexture,
	'CylinderMesh': CylinderMesh,
	'CylinderShape': CylinderShape,
	'DTLSServer': DTLSServer,
	'DampedSpringJoint2D': DampedSpringJoint2D,
	'DirectionalLight': DirectionalLight,
	'DynamicFont': DynamicFont,
	'DynamicFontData': DynamicFontData,
	'EditorExportPlugin': EditorExportPlugin,
	'EditorFeatureProfile': EditorFeatureProfile,
	'EditorFileDialog': EditorFileDialog,
	'EditorFileSystem': EditorFileSystem,
	'EditorFileSystemDirectory': EditorFileSystemDirectory,
	'EditorImportPlugin': EditorImportPlugin,
	'EditorInspector': EditorInspector,
	'EditorInspectorPlugin': EditorInspectorPlugin,
	'EditorInterface': EditorInterface,
	'EditorNavigationMeshGenerator': EditorNavigationMeshGenerator,
	'EditorPlugin': EditorPlugin,
	'EditorProperty': EditorProperty,
	'EditorResourceConversionPlugin': EditorResourceConversionPlugin,
	'EditorResourcePreview': EditorResourcePreview,
	'EditorResourcePreviewGenerator': EditorResourcePreviewGenerator,
	'EditorSceneImporter': EditorSceneImporter,
	'EditorSceneImporterAssimp': EditorSceneImporterAssimp,
	'EditorScenePostImport': EditorScenePostImport,
	'EditorScript': EditorScript,
	'EditorSelection': EditorSelection,
	'EditorSettings': EditorSettings,
	'EditorSpatialGizmo': EditorSpatialGizmo,
	'EditorSpatialGizmoPlugin': EditorSpatialGizmoPlugin,
	'EditorSpinSlider': EditorSpinSlider,
	'EditorVCSInterface': EditorVCSInterface,
	'EncodedObjectAsID': EncodedObjectAsID,
	'Environment': Environment,
	'Expression': Expression,
	'ExternalTexture': ExternalTexture,
	'FileDialog': FileDialog,
	'FileSystemDock': FileSystemDock,
	'Font': Font,
	'FuncRef': FuncRef,
	'GDNative': GDNative,
	'GDNativeLibrary': GDNativeLibrary,
	'GDScript': GDScript,
	'GDScriptFunctionState': GDScriptFunctionState,
	#'GDScriptNativeClass': GDScriptNativeClass,
	'GIProbe': GIProbe,
	'GIProbeData': GIProbeData,
	'Generic6DOFJoint': Generic6DOFJoint,
	'GeometryInstance': GeometryInstance,
	'Gradient': Gradient,
	'GradientTexture': GradientTexture,
	'GraphEdit': GraphEdit,
	'GraphNode': GraphNode,
	'GridContainer': GridContainer,
	'GridMap': GridMap,
	'GrooveJoint2D': GrooveJoint2D,
	'HBoxContainer': HBoxContainer,
	'HScrollBar': HScrollBar,
	'HSeparator': HSeparator,
	'HSlider': HSlider,
	'HSplitContainer': HSplitContainer,
	'HTTPClient': HTTPClient,
	'HTTPRequest': HTTPRequest,
	'HashingContext': HashingContext,
	'HeightMapShape': HeightMapShape,
	'HingeJoint': HingeJoint,
	'IP': IP,
	'IP_Unix': IP_Unix,
	'Image': Image,
	'ImageTexture': ImageTexture,
	'ImmediateGeometry': ImmediateGeometry,
	'Input': Input,
	'InputDefault': InputDefault,
	'InputEvent': InputEvent,
	'InputEventAction': InputEventAction,
	'InputEventGesture': InputEventGesture,
	'InputEventJoypadButton': InputEventJoypadButton,
	'InputEventJoypadMotion': InputEventJoypadMotion,
	'InputEventKey': InputEventKey,
	'InputEventMIDI': InputEventMIDI,
	'InputEventMagnifyGesture': InputEventMagnifyGesture,
	'InputEventMouse': InputEventMouse,
	'InputEventMouseButton': InputEventMouseButton,
	'InputEventMouseMotion': InputEventMouseMotion,
	'InputEventPanGesture': InputEventPanGesture,
	'InputEventScreenDrag': InputEventScreenDrag,
	'InputEventScreenTouch': InputEventScreenTouch,
	'InputEventWithModifiers': InputEventWithModifiers,
	'InputMap': InputMap,
	'InstancePlaceholder': InstancePlaceholder,
	'InterpolatedCamera': InterpolatedCamera,
	'ItemList': ItemList,
	'JNISingleton': JNISingleton,
	'JSONParseResult': JSONParseResult,
	'JSONRPC': JSONRPC,
	'JavaClass': JavaClass,
	'JavaClassWrapper': JavaClassWrapper,
	'JavaScript': JavaScript,
	'Joint': Joint,
	'Joint2D': Joint2D,
	'KinematicBody': KinematicBody,
	'KinematicBody2D': KinematicBody2D,
	'KinematicCollision': KinematicCollision,
	'KinematicCollision2D': KinematicCollision2D,
	'Label': Label,
	'LargeTexture': LargeTexture,
	'Light': Light,
	'Light2D': Light2D,
	'LightOccluder2D': LightOccluder2D,
	'Line2D': Line2D,
	'LineEdit': LineEdit,
	'LineShape2D': LineShape2D,
	'LinkButton': LinkButton,
	'Listener': Listener,
	'MainLoop': MainLoop,
	'MarginContainer': MarginContainer,
	'Material': Material,
	'MenuButton': MenuButton,
	'Mesh': Mesh,
	'MeshDataTool': MeshDataTool,
	'MeshInstance': MeshInstance,
	'MeshInstance2D': MeshInstance2D,
	'MeshLibrary': MeshLibrary,
	'MeshTexture': MeshTexture,
	'MobileVRInterface': MobileVRInterface,
	'MultiMesh': MultiMesh,
	'MultiMeshInstance': MultiMeshInstance,
	'MultiMeshInstance2D': MultiMeshInstance2D,
	'MultiplayerAPI': MultiplayerAPI,
	'MultiplayerPeerGDNative': MultiplayerPeerGDNative,
	'NativeScript': NativeScript,
	'Navigation': Navigation,
	'Navigation2D': Navigation2D,
	'NavigationMesh': NavigationMesh,
	'NavigationMeshInstance': NavigationMeshInstance,
	'NavigationPolygon': NavigationPolygon,
	'NavigationPolygonInstance': NavigationPolygonInstance,
	'NetworkedMultiplayerENet': NetworkedMultiplayerENet,
	'NetworkedMultiplayerPeer': NetworkedMultiplayerPeer,
	'NinePatchRect': NinePatchRect,
	'Node': Node,
	'Node2D': Node2D,
	'NoiseTexture': NoiseTexture,
	#'Object': Object,
	'OccluderPolygon2D': OccluderPolygon2D,
	'OmniLight': OmniLight,
	'OpenSimplexNoise': OpenSimplexNoise,
	'OptionButton': OptionButton,
	'PCKPacker': PCKPacker,
	'PHashTranslation': PHashTranslation,
	'PackedDataContainer': PackedDataContainer,
	'PackedDataContainerRef': PackedDataContainerRef,
	'PackedScene': PackedScene,
	'PacketPeer': PacketPeer,
	'PacketPeerDTLS': PacketPeerDTLS,
	'PacketPeerGDNative': PacketPeerGDNative,
	'PacketPeerStream': PacketPeerStream,
	'PacketPeerUDP': PacketPeerUDP,
	'Panel': Panel,
	'PanelContainer': PanelContainer,
	'PanoramaSky': PanoramaSky,
	'ParallaxBackground': ParallaxBackground,
	'ParallaxLayer': ParallaxLayer,
	'Particles': Particles,
	'Particles2D': Particles2D,
	'ParticlesMaterial': ParticlesMaterial,
	'Path': Path,
	'Path2D': Path2D,
	'PathFollow': PathFollow,
	'PathFollow2D': PathFollow2D,
	'Performance': Performance,
	'PhysicalBone': PhysicalBone,
	'Physics2DDirectBodyState': Physics2DDirectBodyState,
	'Physics2DDirectBodyStateSW': Physics2DDirectBodyStateSW,
	'Physics2DDirectSpaceState': Physics2DDirectSpaceState,
	#'Physics2DDirectSpaceStateSW': Physics2DDirectSpaceStateSW,
	'Physics2DServer': Physics2DServer,
	'Physics2DServerSW': Physics2DServerSW,
	'Physics2DShapeQueryParameters': Physics2DShapeQueryParameters,
	'Physics2DShapeQueryResult': Physics2DShapeQueryResult,
	'Physics2DTestMotionResult': Physics2DTestMotionResult,
	'PhysicsBody': PhysicsBody,
	'PhysicsBody2D': PhysicsBody2D,
	'PhysicsDirectBodyState': PhysicsDirectBodyState,
	'PhysicsDirectSpaceState': PhysicsDirectSpaceState,
	'PhysicsMaterial': PhysicsMaterial,
	'PhysicsServer': PhysicsServer,
	'PhysicsShapeQueryParameters': PhysicsShapeQueryParameters,
	'PhysicsShapeQueryResult': PhysicsShapeQueryResult,
	'PinJoint': PinJoint,
	'PinJoint2D': PinJoint2D,
	'PlaneMesh': PlaneMesh,
	'PlaneShape': PlaneShape,
	'PluginScript': PluginScript,
	'PointMesh': PointMesh,
	'Polygon2D': Polygon2D,
	'PolygonPathFinder': PolygonPathFinder,
	'Popup': Popup,
	'PopupDialog': PopupDialog,
	'PopupMenu': PopupMenu,
	'PopupPanel': PopupPanel,
	'Position2D': Position2D,
	'Position3D': Position3D,
	'PrimitiveMesh': PrimitiveMesh,
	'PrismMesh': PrismMesh,
	'ProceduralSky': ProceduralSky,
	'ProgressBar': ProgressBar,
	'ProjectSettings': ProjectSettings,
	'ProximityGroup': ProximityGroup,
	'ProxyTexture': ProxyTexture,
	'QuadMesh': QuadMesh,
	'RandomNumberGenerator': RandomNumberGenerator,
	'Range': Range,
	'RayCast': RayCast,
	'RayCast2D': RayCast2D,
	'RayShape': RayShape,
	'RayShape2D': RayShape2D,
	'RectangleShape2D': RectangleShape2D,
	'Reference': Reference,
	'ReferenceRect': ReferenceRect,
	'ReflectionProbe': ReflectionProbe,
	'RegEx': RegEx,
	'RegExMatch': RegExMatch,
	'RemoteTransform': RemoteTransform,
	'RemoteTransform2D': RemoteTransform2D,
	'Resource': Resource,
	'ResourceFormatLoader': ResourceFormatLoader,
	'ResourceFormatSaver': ResourceFormatSaver,
	'ResourceImporter': ResourceImporter,
	'ResourceInteractiveLoader': ResourceInteractiveLoader,
	'ResourcePreloader': ResourcePreloader,
	'RichTextEffect': RichTextEffect,
	'RichTextLabel': RichTextLabel,
	'RigidBody': RigidBody,
	'RigidBody2D': RigidBody2D,
	'RootMotionView': RootMotionView,
	'SceneState': SceneState,
	'SceneTree': SceneTree,
	'SceneTreeTimer': SceneTreeTimer,
	'Script': Script,
	'ScriptCreateDialog': ScriptCreateDialog,
	'ScriptEditor': ScriptEditor,
	'ScrollBar': ScrollBar,
	'ScrollContainer': ScrollContainer,
	'SegmentShape2D': SegmentShape2D,
	'Separator': Separator,
	'Shader': Shader,
	'ShaderMaterial': ShaderMaterial,
	'Shape': Shape,
	'Shape2D': Shape2D,
	'ShortCut': ShortCut,
	'Skeleton': Skeleton,
	'Skeleton2D': Skeleton2D,
	'SkeletonIK': SkeletonIK,
	'Skin': Skin,
	'SkinReference': SkinReference,
	'Sky': Sky,
	'Slider': Slider,
	'SliderJoint': SliderJoint,
	'SoftBody': SoftBody,
	'Spatial': Spatial,
	'SpatialGizmo': SpatialGizmo,
	'SpatialMaterial': SpatialMaterial,
	'SpatialVelocityTracker': SpatialVelocityTracker,
	'SphereMesh': SphereMesh,
	'SphereShape': SphereShape,
	'SpinBox': SpinBox,
	'SplitContainer': SplitContainer,
	'SpotLight': SpotLight,
	'SpringArm': SpringArm,
	'Sprite': Sprite,
	'Sprite3D': Sprite3D,
	'SpriteBase3D': SpriteBase3D,
	'SpriteFrames': SpriteFrames,
	'StaticBody': StaticBody,
	'StaticBody2D': StaticBody2D,
	'StreamPeer': StreamPeer,
	'StreamPeerBuffer': StreamPeerBuffer,
	'StreamPeerGDNative': StreamPeerGDNative,
	'StreamPeerSSL': StreamPeerSSL,
	'StreamPeerTCP': StreamPeerTCP,
	'StreamTexture': StreamTexture,
	'StyleBox': StyleBox,
	'StyleBoxEmpty': StyleBoxEmpty,
	'StyleBoxFlat': StyleBoxFlat,
	'StyleBoxLine': StyleBoxLine,
	'StyleBoxTexture': StyleBoxTexture,
	'SurfaceTool': SurfaceTool,
	'TCP_Server': TCP_Server,
	'TabContainer': TabContainer,
	'Tabs': Tabs,
	'TextEdit': TextEdit,
	'TextFile': TextFile,
	'Texture': Texture,
	'Texture3D': Texture3D,
	'TextureArray': TextureArray,
	'TextureButton': TextureButton,
	'TextureLayered': TextureLayered,
	'TextureProgress': TextureProgress,
	'TextureRect': TextureRect,
	'Theme': Theme,
	'TileMap': TileMap,
	'TileSet': TileSet,
	'Timer': Timer,
	'ToolButton': ToolButton,
	'TouchScreenButton': TouchScreenButton,
	'Translation': Translation,
	'TranslationServer': TranslationServer,
	'Tree': Tree,
	'TreeItem': TreeItem,
	'TriangleMesh': TriangleMesh,
	'Tween': Tween,
	'UDPServer': UDPServer,
	'UPNP': UPNP,
	'UPNPDevice': UPNPDevice,
	'UndoRedo': UndoRedo,
	'VBoxContainer': VBoxContainer,
	'VScrollBar': VScrollBar,
	'VSeparator': VSeparator,
	'VSlider': VSlider,
	'VSplitContainer': VSplitContainer,
	'VehicleBody': VehicleBody,
	'VehicleWheel': VehicleWheel,
	'VideoPlayer': VideoPlayer,
	'VideoStream': VideoStream,
	'VideoStreamGDNative': VideoStreamGDNative,
	'VideoStreamTheora': VideoStreamTheora,
	'VideoStreamWebm': VideoStreamWebm,
	'Viewport': Viewport,
	'ViewportContainer': ViewportContainer,
	'ViewportTexture': ViewportTexture,
	'VisibilityEnabler': VisibilityEnabler,
	'VisibilityEnabler2D': VisibilityEnabler2D,
	'VisibilityNotifier': VisibilityNotifier,
	'VisibilityNotifier2D': VisibilityNotifier2D,
	'VisualInstance': VisualInstance,
	'VisualScript': VisualScript,
	'VisualScriptBasicTypeConstant': VisualScriptBasicTypeConstant,
	'VisualScriptBuiltinFunc': VisualScriptBuiltinFunc,
	'VisualScriptClassConstant': VisualScriptClassConstant,
	'VisualScriptComment': VisualScriptComment,
	'VisualScriptComposeArray': VisualScriptComposeArray,
	'VisualScriptCondition': VisualScriptCondition,
	'VisualScriptConstant': VisualScriptConstant,
	'VisualScriptConstructor': VisualScriptConstructor,
	'VisualScriptCustomNode': VisualScriptCustomNode,
	'VisualScriptDeconstruct': VisualScriptDeconstruct,
	'VisualScriptEmitSignal': VisualScriptEmitSignal,
	'VisualScriptEngineSingleton': VisualScriptEngineSingleton,
	'VisualScriptExpression': VisualScriptExpression,
	'VisualScriptFunction': VisualScriptFunction,
	'VisualScriptFunctionCall': VisualScriptFunctionCall,
	'VisualScriptFunctionState': VisualScriptFunctionState,
	'VisualScriptGlobalConstant': VisualScriptGlobalConstant,
	'VisualScriptIndexGet': VisualScriptIndexGet,
	'VisualScriptIndexSet': VisualScriptIndexSet,
	'VisualScriptInputAction': VisualScriptInputAction,
	'VisualScriptIterator': VisualScriptIterator,
	'VisualScriptLists': VisualScriptLists,
	'VisualScriptLocalVar': VisualScriptLocalVar,
	'VisualScriptLocalVarSet': VisualScriptLocalVarSet,
	'VisualScriptMathConstant': VisualScriptMathConstant,
	'VisualScriptNode': VisualScriptNode,
	'VisualScriptOperator': VisualScriptOperator,
	'VisualScriptPreload': VisualScriptPreload,
	'VisualScriptPropertyGet': VisualScriptPropertyGet,
	'VisualScriptPropertySet': VisualScriptPropertySet,
	'VisualScriptResourcePath': VisualScriptResourcePath,
	'VisualScriptReturn': VisualScriptReturn,
	'VisualScriptSceneNode': VisualScriptSceneNode,
	'VisualScriptSceneTree': VisualScriptSceneTree,
	'VisualScriptSelect': VisualScriptSelect,
	'VisualScriptSelf': VisualScriptSelf,
	'VisualScriptSequence': VisualScriptSequence,
	'VisualScriptSubCall': VisualScriptSubCall,
	'VisualScriptSwitch': VisualScriptSwitch,
	'VisualScriptTypeCast': VisualScriptTypeCast,
	'VisualScriptVariableGet': VisualScriptVariableGet,
	'VisualScriptVariableSet': VisualScriptVariableSet,
	'VisualScriptWhile': VisualScriptWhile,
	'VisualScriptYield': VisualScriptYield,
	'VisualScriptYieldSignal': VisualScriptYieldSignal,
	'VisualServer': VisualServer,
	'VisualShader': VisualShader,
	'VisualShaderNode': VisualShaderNode,
	'VisualShaderNodeBooleanConstant': VisualShaderNodeBooleanConstant,
	'VisualShaderNodeBooleanUniform': VisualShaderNodeBooleanUniform,
	'VisualShaderNodeColorConstant': VisualShaderNodeColorConstant,
	'VisualShaderNodeColorFunc': VisualShaderNodeColorFunc,
	'VisualShaderNodeColorOp': VisualShaderNodeColorOp,
	'VisualShaderNodeColorUniform': VisualShaderNodeColorUniform,
	'VisualShaderNodeCompare': VisualShaderNodeCompare,
	'VisualShaderNodeCubeMap': VisualShaderNodeCubeMap,
	'VisualShaderNodeCubeMapUniform': VisualShaderNodeCubeMapUniform,
	'VisualShaderNodeCustom': VisualShaderNodeCustom,
	'VisualShaderNodeDeterminant': VisualShaderNodeDeterminant,
	'VisualShaderNodeDotProduct': VisualShaderNodeDotProduct,
	'VisualShaderNodeExpression': VisualShaderNodeExpression,
	'VisualShaderNodeFaceForward': VisualShaderNodeFaceForward,
	'VisualShaderNodeFresnel': VisualShaderNodeFresnel,
	'VisualShaderNodeGlobalExpression': VisualShaderNodeGlobalExpression,
	'VisualShaderNodeGroupBase': VisualShaderNodeGroupBase,
	'VisualShaderNodeIf': VisualShaderNodeIf,
	'VisualShaderNodeInput': VisualShaderNodeInput,
	'VisualShaderNodeIs': VisualShaderNodeIs,
	'VisualShaderNodeOuterProduct': VisualShaderNodeOuterProduct,
	'VisualShaderNodeOutput': VisualShaderNodeOutput,
	'VisualShaderNodeScalarClamp': VisualShaderNodeScalarClamp,
	'VisualShaderNodeScalarConstant': VisualShaderNodeScalarConstant,
	'VisualShaderNodeScalarDerivativeFunc': VisualShaderNodeScalarDerivativeFunc,
	'VisualShaderNodeScalarFunc': VisualShaderNodeScalarFunc,
	'VisualShaderNodeScalarInterp': VisualShaderNodeScalarInterp,
	'VisualShaderNodeScalarOp': VisualShaderNodeScalarOp,
	'VisualShaderNodeScalarSmoothStep': VisualShaderNodeScalarSmoothStep,
	'VisualShaderNodeScalarSwitch': VisualShaderNodeScalarSwitch,
	'VisualShaderNodeScalarUniform': VisualShaderNodeScalarUniform,
	'VisualShaderNodeSwitch': VisualShaderNodeSwitch,
	'VisualShaderNodeTexture': VisualShaderNodeTexture,
	'VisualShaderNodeTextureUniform': VisualShaderNodeTextureUniform,
	'VisualShaderNodeTextureUniformTriplanar': VisualShaderNodeTextureUniformTriplanar,
	'VisualShaderNodeTransformCompose': VisualShaderNodeTransformCompose,
	'VisualShaderNodeTransformConstant': VisualShaderNodeTransformConstant,
	'VisualShaderNodeTransformDecompose': VisualShaderNodeTransformDecompose,
	'VisualShaderNodeTransformFunc': VisualShaderNodeTransformFunc,
	'VisualShaderNodeTransformMult': VisualShaderNodeTransformMult,
	'VisualShaderNodeTransformUniform': VisualShaderNodeTransformUniform,
	'VisualShaderNodeTransformVecMult': VisualShaderNodeTransformVecMult,
	'VisualShaderNodeUniform': VisualShaderNodeUniform,
	'VisualShaderNodeVec3Constant': VisualShaderNodeVec3Constant,
	'VisualShaderNodeVec3Uniform': VisualShaderNodeVec3Uniform,
	'VisualShaderNodeVectorClamp': VisualShaderNodeVectorClamp,
	'VisualShaderNodeVectorCompose': VisualShaderNodeVectorCompose,
	'VisualShaderNodeVectorDecompose': VisualShaderNodeVectorDecompose,
	'VisualShaderNodeVectorDerivativeFunc': VisualShaderNodeVectorDerivativeFunc,
	'VisualShaderNodeVectorDistance': VisualShaderNodeVectorDistance,
	'VisualShaderNodeVectorFunc': VisualShaderNodeVectorFunc,
	'VisualShaderNodeVectorInterp': VisualShaderNodeVectorInterp,
	'VisualShaderNodeVectorLen': VisualShaderNodeVectorLen,
	'VisualShaderNodeVectorOp': VisualShaderNodeVectorOp,
	'VisualShaderNodeVectorRefract': VisualShaderNodeVectorRefract,
	'VisualShaderNodeVectorScalarMix': VisualShaderNodeVectorScalarMix,
	'VisualShaderNodeVectorScalarSmoothStep': VisualShaderNodeVectorScalarSmoothStep,
	'VisualShaderNodeVectorScalarStep': VisualShaderNodeVectorScalarStep,
	'VisualShaderNodeVectorSmoothStep': VisualShaderNodeVectorSmoothStep,
	'WeakRef': WeakRef,
	'WebRTCDataChannel': WebRTCDataChannel,
	'WebRTCDataChannelGDNative': WebRTCDataChannelGDNative,
	'WebRTCMultiplayer': WebRTCMultiplayer,
	'WebRTCPeerConnection': WebRTCPeerConnection,
	'WebRTCPeerConnectionGDNative': WebRTCPeerConnectionGDNative,
	'WebSocketClient': WebSocketClient,
	'WebSocketMultiplayerPeer': WebSocketMultiplayerPeer,
	'WebSocketPeer': WebSocketPeer,
	'WebSocketServer': WebSocketServer,
	'WindowDialog': WindowDialog,
	'World': World,
	'World2D': World2D,
	'WorldEnvironment': WorldEnvironment,
	'X509Certificate': X509Certificate,
	'XMLParser': XMLParser,
	'YSort': YSort,
	'ClassDB': ClassDB,
	'Directory': Directory,
	'Engine': Engine,
	'File': File,
	'Geometry': Geometry,
	'JSON': JSON,
	'Marshalls': Marshalls,
	'Mutex': Mutex,
	'OS': OS,
	'ResourceLoader': ResourceLoader,
	'ResourceSaver': ResourceSaver,
	'Semaphore': Semaphore,
	'Thread': Thread,
	'VisualScriptEditor': VisualScriptEditor,
}

# Called when the node enters the scene tree for the first time.
func _ready():
	input.grab_focus()

func gd_eval(gd_expr: String) -> Array:
	var errstr = 'Error: '
	var expression = Expression.new()
	var error = expression.parse(gd_expr, variables.keys())
	if error != OK:
		errstr += 'invalid expression: '
		errstr += expression.get_error_text()
		return [false, errstr]
	var result = expression.execute(variables.values())
	if expression.has_execute_failed():
		errstr += 'execute failed: '
		var gderr = expression.get_error_text()
		if gderr == "self can't be used because instance is null (not passed)":
			gderr += ' [variable not declared?]'
		errstr += gderr
		return [false, errstr]
	return [true, result]

func eval_input():
	if input.text == '':
		output.text += '> \n'
		return
	
	hist[len(hist)-1] = input.text
	hist.push_back('')
	hist_index = len(hist) - 1
	
	output.text += '> ' + input.text + '\n'
	
	var ret = null
	
	# Assignment re-implementation (missing in Expression)
	# TODO: d[x] += 1
	var var_name = null
	var regex_var = RegEx.new()
	var result
	regex_var.compile("^\\s*(var\\s+)?(?<variable>[a-zA-Z_][a-zA-Z_0-9]*)\\s*?=\\s*?(?<rest>.*)")
	result = regex_var.search(input.text)
	if result:
		var_name = result.get_string('variable')
		input.text = result.get_string('rest')
	
	# load() support
	var path = null
	var regex_load = RegEx.new()
	regex_load.compile("^load\\(\"(?<path>[^\\\"]*)\"\\)|load\\(\'(?<path>[^\\\"]*)\'\\)")
	result = regex_load.search(input.text)
	if result:
		path = result.get_string('path')
		ret = load(path)
		ret = [true, ret]
	
	if ret == null:
		ret = gd_eval(input.text)
	
	if var_name != null and ret[0]:
		output.text += '* setting variable %s *\n' % var_name
		variables[var_name] = ret[1]
	
	output.text += str(ret[1]) + "\n"
	input.text = ''
	
	input.grab_focus()

func _on_eval_pressed():
	eval_input()

func _on_input_text_entered(_new_text):
	eval_input()

func _on_import_pressed():
	if input.text.empty():
		output.text += 'Please type a variable name.\n'
		input.grab_focus()
		return
	find_node('import_filedialog').popup()

func _on_import_filedialog_file_selected(path):
	var name = input.text
	variables[name] = load(path).instance()
	output.text += '> %s = %s\n' % [name, variables[name]]
	input.text = ''
	input.grab_focus()

func _on_input_gui_input(event):
	if event.is_action_pressed('ui_up'):
		hist[hist_index] = input.text
		hist_index = hist_index-1 if (hist_index > 0) else hist_index
		input.text = hist[hist_index]
		input.caret_position = len(input.text)
		accept_event()
	if event.is_action_pressed('ui_down'):
		hist[hist_index] = input.text
		hist_index = hist_index+1 if (hist_index < len(hist)-1) else hist_index
		input.text = hist[hist_index]
		input.caret_position = len(input.text)
		accept_event()

# TODO: reset button
# TODO: i18n
