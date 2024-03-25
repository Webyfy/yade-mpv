mp.observe_property("focused", "bool", function(name, value)
    if value == false then
        paused_before_losing_focus = mp.get_property_native("pause")
        mp.set_property_native("pause", true)
    else
        mp.set_property_native("pause", paused_before_losing_focus)
    end
end)