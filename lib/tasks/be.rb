# frozen_string_literal: true
#

collection_namespace 'Be' do
  # TODO are there actually metrowerks docs for R4 and earlier, somewhere other than develop/BeIDE?
  collection_namespace 'BeOS' do
    manual_namespace 'PR2',
                    vendor_class: BeOS::PR2,
                    odir: 'Be/BeOS/PR2',
                    sources: %w[
                      beos/documentation
                      beos/documentation/Be?Book
                      beos/documentation/Be?Book/*/*.html
                      beos/documentation/BeOS?Product?Information
                      beos/documentation/FAQs
                      beos/documentation/Shell?Tools
                      beos/documentation/Shell?Tools/man1
                      beos/documentation/User?s?Guide/HTML/*.html
                    ] do |t|
                      assets_task %w(*.jp*g *.[gG][iI][fF] *.pdf), t[:idir], t[:odir], cut_dirs: 2
                      task all: [:assets]
                    end

    # the gifs in the R3 ./graphics/ & pressinfo/resources (not belogos/) directories are macbinary encoded
    manual_namespace 'R3',
                    vendor_class: BeOS::R3,
                    odir: 'Be/BeOS/R3',
                    sources: %w[
                      beos/documentation
                      beos/documentation/Be?Book
                      beos/documentation/Be?Book/[DGPT]*/*.html
                      beos/documentation/BeOS_Product_Information
                      beos/documentation/notes
                      beos/documentation/PressInfo
                      beos/documentation/PressInfo/[anr]*/*.html
                      beos/documentation/PressInfo/aboutbe/*/*.html
                      beos/documentation/PressInfo/aboutbe/*/news_images/*.html
                      beos/documentation/PressInfo/aboutbe/pressphotos/*/*.html
                      beos/documentation/PressInfo/resources/*/*.html
                      beos/documentation/Release_Notes
                      beos/documentation/Shell?Tools
                      beos/documentation/Shell?Tools/man1
                      beos/documentation/The_Be_FAQs
                      beos/documentation/The_Be_FAQs/faqs
                      beos/documentation/User?s?Guide
                    ] do |t|
                      assets_task %w(*.jp*g *.[gG][iI][fF] *.map *.tiff *.eps), t[:idir], t[:odir], cut_dirs: 2, postprocess: :process_macbinary
                      task all: [:assets]
                    end

    manual_namespace 'R4',
                    vendor_class: BeOS::R4,
                    odir: 'Be/BeOS/R4',
                    sources: %w[
                      beos/documentation
                      beos/documentation/AlertInfo
                      beos/documentation/Be?Book
                      beos/documentation/Be?Book/[PRT]*/*.html
                      beos/documentation/BeOS_Product_Information
                      beos/documentation/BeOS_Product_Information/beos_tour/*.html
                      beos/documentation/Shell?Tools
                      beos/documentation/Shell?Tools/man1
                      beos/documentation/The_Be_FAQs
                      beos/documentation/The_Be_FAQs/faqs
                      beos/documentation/User?s?Guide
                      beos/documentation/User?s?Guide/[0AR]*
                      beos/documentation/Virtual_Press_Kit
                      beos/documentation/Virtual_Press_Kit/aboutbe
                      beos/documentation/Virtual_Press_Kit/aboutbe/[ln]*/*.html
                      beos/documentation/Virtual_Press_Kit/aboutbe/pressreleases
                    ] do |t|
                      assets_task %w(*.jp*g *.[gG][iI][fF] *.eps), t[:idir], t[:odir], cut_dirs: 2
                      task all: [:assets]
                    end

    manual_namespace 'R4.5',
                    vendor_class: BeOS::R4_5,
                    odir: 'Be/BeOS/R4.5',
                    sources: %w[
                      beos/documentation
                      beos/documentation/AlertInfo
                      beos/documentation/AlertInfo/ATCommands
                      beos/documentation/Be?Book
                      beos/documentation/Be?Book/[A-Z]*
                      beos/documentation/Be?Book/Release?Notes/[bB]*
                      beos/documentation/BeOS_Product_Information
                      beos/documentation/BeOS_Product_Information/beos_tour/*.html
                      beos/documentation/Shell?Tools
                      beos/documentation/Shell?Tools/man1
                      beos/documentation/Shell?Tools/ref/*
                      beos/documentation/User?s?Guide
                      beos/documentation/User?s?Guide/0[1-7]_*
                      beos/documentation/User?s?Guide/Appx*
                      beos/documentation/User?s?Guide/French
                      beos/documentation/User?s?Guide/French/[0A]*
                      beos/documentation/User?s?Guide/German
                      beos/documentation/User?s?Guide/German/[0A]*
                      beos/documentation/User?s?Guide/Release?Notes*
                      beos/documentation/User?s?Guide/Release?Notes*/3DMixer
                      beos/documentation/Virtual_Press_Kit
                      beos/documentation/Virtual_Press_Kit/aboutbe
                      beos/documentation/Virtual_Press_Kit/aboutbe/[ln]*/*.html
                      beos/documentation/Virtual_Press_Kit/aboutbe/pressreleases
                      develop/BeIDE/Documentation/BeOS?doc?/*_html
                    ] do |t|
                      assets_task %w(beos/**/*.jp*g beos/**/*.[gG][iI][fF]), t[:idir], t[:odir], cut_dirs: 2
                      assets_task %w(develop/**/*.[gG][iI][fF]), t[:idir], t[:odir], cut_dirs: 1
                      task all: [:assets]
                    end

    manual_namespace 'R5',
                    vendor_class: BeOS::R5,
                    odir: 'Be/BeOS/R5',
                    sources: %w[
                      beos/documentation
                      beos/documentation/AlertInfo
                      beos/documentation/AlertInfo/ATCommands
                      beos/documentation/Be?Book
                      beos/documentation/Be?Book/[A-Z]*
                      beos/documentation/BinkJet?2.0
                      beos/documentation/BinkJet?2.0/[ds]*/*.html
                      beos/documentation/Shell?Tools
                      beos/documentation/Shell?Tools/man1
                      beos/documentation/Shell?Tools/ref/*
                      beos/documentation/User?s?Guide
                      beos/documentation/User?s?Guide/0[1-7]_*
                      develop/BeIDE/Documentation/BeOS?doc?/*_html
                    ] do |t|
                      assets_task %w(beos/**/*.jp*g beos/**/*.[gG][iI][fF]), t[:idir], t[:odir], cut_dirs: 2
                      assets_task %w(develop/**/*.[gG][iI][fF]), t[:idir], t[:odir], cut_dirs: 1
                      task all: [:assets]
                    end
  end
end
