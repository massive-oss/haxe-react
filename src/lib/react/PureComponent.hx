package react;

import react.ReactComponent;

typedef PureComponent = PureComponentOf<Dynamic, Dynamic>;
typedef PureComponentOfProps<TProps> = PureComponentOf<TProps, Dynamic>;
typedef PureComponentOfState<TState> = PureComponentOf<Dynamic, TState>;
typedef PureComponentOfPropsAndState<TProps, TState> = PureComponentOf<TProps, TState>;

#if (!react_global)
@:jsRequire("react", "PureComponent")
#end
@:native('React.PureComponent')
@:keepSub
extern class PureComponentOf<TProps, TState>
extends ReactComponentOf<TProps, TState>
{}
