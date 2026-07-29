# frozen_string_literal: true
#

require_relative 'qnx/momentics'

collection_namespace 'QNX' do
  collection_namespace 'Momentics' do
    manual_namespace '6.3.2',
      vendor_class: Momentics,
      odir: 'QNX/Momentics/6.3.2',
      sources: %w[
        usr/man/man1
        usr/qnx632/target/qnx6/usr/help/product/*/*.html
        usr/qnx632/target/qnx6/usr/help/product/*/*/*.html
        usr/qnx632/target/qnx6/usr/help/product/*/*/*/*.html
      ] do |t|
        assets_task %w(usr/qnx632/target/qnx6/usr/help/product/**/*.jpg
                       usr/qnx632/target/qnx6/usr/help/product/**/*.gif), t[:idir], t[:odir], cut_dirs: 6
        task all: [:assets]
      end
  end
end
