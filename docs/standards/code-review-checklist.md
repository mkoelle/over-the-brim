# Code Review Checklist

## Before Approving

- [ ] Static typing used on all variables and return types
- [ ] No allocations in _process() or _physics_process()
- [ ] Node references cached with @onready
- [ ] Signals used instead of direct dependencies where possible
- [ ] Scene has single responsibility
- [ ] No gameplay state owned by UI
- [ ] Player ownership is explicit
- [ ] Inheritance depth is 3 or less
- [ ] New files do not duplicate existing system functionality
- [ ] Architecture dependency flow is respected (UI → Presentation → Systems → Data)
