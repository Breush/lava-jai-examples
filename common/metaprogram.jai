Basic :: #import "Basic";
Compiler :: #import "Compiler";
File :: #import "File";
String :: #import "String";

#load "../lava/modules/Sill/plugin.jai";

make_example_workspace :: (exampleName : string) {
    Basic.set_working_directory(#filepath);
    File.make_directory_if_it_does_not_exist("../bin");

    workspace := Compiler.compiler_create_workspace(exampleName);

    options := Compiler.get_build_options();
    options.output_executable_name  = exampleName;
    options.output_path             = String.join(#filepath, "../bin/");
    options.optimization_level      = .DEBUG;

    import_path: [..] string;
    Basic.array_add(*import_path, "../lava/bindings");
    Basic.array_add(*import_path, "../lava/modules");
    Basic.array_add(*import_path, ..options.import_path);
    options.import_path = import_path;

    if options.os_target == .LINUX {
        arguments: [..] string;
        Basic.array_add(*arguments, "-rpath=$ORIGIN");
        Basic.array_add(*arguments, Basic.tprint("-rpath=%../lava/bindings/StbTrueType", #filepath));
        Basic.array_add(*arguments, Basic.tprint("-rpath=%../lava/bindings/Vulkan", #filepath));
        Basic.array_add(*arguments, Basic.tprint("-rpath=%../lava/bindings/Shaderc", #filepath));
        Basic.array_add(*arguments, Basic.tprint("-rpath=%../lava/bindings/OpenXr", #filepath));
        options.additional_linker_arguments = arguments;
    }

    // Building our main program
    Compiler.set_build_options(options, workspace);

    Compiler.compiler_begin_intercept(workspace);
    Compiler.add_build_file(String.join("../examples/", exampleName, "/main.jai"), workspace);

    while true {
        message := Compiler.compiler_wait_for_message();
        if !message break;
        if message.workspace != workspace continue;

        // @note One can use the -plug Sill/plugin instead.
        sill_plugin_message(null, message);

        if message.kind == .COMPLETE {
            break;
        }
    }

    Compiler.compiler_end_intercept(workspace);

    // Do not generate executable for this build program
    Compiler.set_build_options_dc(.{ do_output = false });
}
