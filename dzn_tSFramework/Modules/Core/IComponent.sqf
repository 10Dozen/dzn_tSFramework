#include "script_component.hpp"

[
    ["#type", Q(COMPONENT_IFACE)],
    ["#name", ""],
    ["#str", { "tSF_IComponent" }],
    [COMPONENT_STATUS_VARNAME, COMPONENT_STATUS_STARTING],

    ["#setStatus", {
        private _currentStatus = _self get COMPONENT_STATUS_VARNAME;

        // -- Self-hosted server case: for debugging and mission creation
        //    skip changing status if already set by server-side/client-side part
        if (
            isServer && hasInterface
            && _currentStatus != COMPONENT_STATUS_STARTING
        ) exitWith {};

        diag_log text format [
            "[%1] (%2): %3: Component initialization status => %4",
            Q(PREFIX), _self get "#name",
            ["LOG", "ERR"] select (_this == COMPONENT_STATUS_FAILED),
            _this
        ];
        _self set [COMPONENT_STATUS_VARNAME, _this];
    }],

    [F(initServer), {
        diag_log "(INHERITED) INIT SERVER";
        _self call ["#setStatus", COMPONENT_STATUS_OK];
        //LOG("Server initialized");
    }],
    [F(initClient), {
        diag_log "(INHERITED) INIT CLIENT";
        _self call ["#setStatus", COMPONENT_STATUS_OK];
        //LOG("Client initialized");
    }]
]