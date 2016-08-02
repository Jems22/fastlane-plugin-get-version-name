module Fastlane
  module Actions
    class GetVersionNameAction < Action
        def self.run(params)
          app_folder_name ||= params[:app_folder_name]
          UI.message("The getversionname plugin is looking inside your project folder (#{app_folder_name})!")

          version_name = "0"

          Dir.glob("**/#{app_folder_name}/build.gradle") do |path|
              begin
                  file = File.new(path, "r")
                  while (line = file.gets)
                      if line.include? "versionName"
                         versionComponents = line.strip.split(' ')
                         version_name = versionComponents[1].tr("\"","")
                         break
                      end
                  end
                  file.close
              rescue => err
                  UI.error("An exception occured while readinf gradle file: #{err}")
                  err
              end
          end

          if version_name == "0"
              UI.user_error!("Impossible to find the version name in the current project folder #{app_folder_name} 😭")
          else
              # Store the version name in the shared hash
              Actions.lane_context["VERSION_NAME"]=version_name
              UI.success("👍 Version name found: #{version_name}")
          end

          return version_name

        end

        def self.description
          "Get the version name of an Android project. This action will return the version name of your project according to the one set in your build.gradle file"
        end

        def self.authors
          ["Jérémy TOUDIC"]
        end

        def self.available_options
          [
            FastlaneCore::ConfigItem.new(key: :app_folder_name,
                                    env_name: "GETVERSIONNAME_APP_VERSION_NAME",
                                 description: "The name of the application source folder in the Android project (default: app)",
                                    optional: true,
                                        type: String,
                               default_value:"app")
          ]
        end

        def self.output
          [
            ['VERSION_NAME', 'The version name']
          ]
        end

        def self.is_supported?(platform)
          [:android].include?(platform)
        end
      end
    end
  end
