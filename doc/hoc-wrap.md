# Wrapping your components in HOCs

You can use HOCs with your components by adding `@:wrap` meta.

Note: not compatible with `@jsxStatic` meta.

In JavaScript it may look like that:
```javascript
import React from 'react';
import { withRouter } from 'react-router';

class MyComponent extends React.Component {
    render() {
        return (
            <p>Current path is {this.props.location.pathname}</p>
        );
    }
}

// HOC wrap
export default withRouter(MyComponent);
```

In Haxe it will be:

```haxe
import react.ReactComponent;
import react.ReactMacro.jsx;
import react.router.ReactRouter;
import react.router.Route.RouteRenderProps;

@:wrap(ReactRouter.withRouter)
class MyComponent extends ReactComponentOfProps<RouteRenderProps> {
	function render() {
		return jsx(
            '<p>Current path is ${props.location.pathname}</p>'
        );
	}
}
```

You can add multime `@:wrap` metas:

```haxe
import react.ReactComponent;
import react.ReactMacro.jsx;
import react.React.CreateElementType;
import react.router.ReactRouter;
import react.router.Route.RouteRenderProps;

// combined props
private typedef Props = {
	> RouteRenderProps,
	var answer: Int;
}

@:wrap(ReactRouter.withRouter)
@:wrap(uselessHoc(42))
class MyComponent extends ReactComponentOfProps<Props> {

	static function uselessHoc(value:Int) {
		return function(Comp: CreateElementType) {
			return function(props: Any) {
				return jsx('<$Comp {...props} answer=${value} />');
			};
		};
	}

	function render() {
		return jsx('
			<p>
				Current path is ${props.location.pathname} and the answer is ${props.answer}
			</p>
		');
	}
}
```
