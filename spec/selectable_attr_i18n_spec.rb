# -*- coding: utf-8 -*-
if defined?(I18n)
  require File.expand_path('spec_helper', File.dirname(__FILE__))

  describe SelectableAttr::Enum do

    before(:each) do
      I18n.backend = I18n::Backend::Simple.new
      I18n.backend.store_translations 'en', 'selectable_attrs' => {'enum1' => {
          'entry1' => 'entry one',
          'entry2' => 'entry two',
          'entry3' => 'entry three'
        } }
      I18n.backend.store_translations 'ja', 'selectable_attrs' => {'enum1' => {
          'entry1' => 'エントリ壱',
          'entry2' => 'エントリ弐',
          'entry3' => 'エントリ参'
        } }
    end

    Enum1 = SelectableAttr::Enum.new do
      i18n_scope(:selectable_attrs, :enum1)
      entry 1, :entry1, "エントリ1"
      entry 2, :entry2, "エントリ2"
      entry 3, :entry3, "エントリ3"
    end

    it 'test_enum1_i18n' do
      I18n.locale = nil
      I18n.locale.should == :en
      Enum1.name_by_key(:entry1).should == "entry one"
      Enum1.name_by_key(:entry2).should == "entry two"
      Enum1.name_by_key(:entry3).should == "entry three"
      Enum1.names.should == ["entry one", "entry two", "entry three"]

      I18n.locale = 'ja'
      Enum1.name_by_key(:entry1).should == "エントリ壱"
      Enum1.name_by_key(:entry2).should == "エントリ弐"
      Enum1.name_by_key(:entry3).should == "エントリ参"
      Enum1.names.should == ["エントリ壱", "エントリ弐", "エントリ参"]

      I18n.locale = 'en'
      Enum1.name_by_key(:entry1).should == "entry one"
      Enum1.name_by_key(:entry2).should == "entry two"
      Enum1.name_by_key(:entry3).should == "entry three"
      Enum1.names.should == ["entry one", "entry two", "entry three"]
    end

    class EnumBase
      include ::SelectableAttr::Base
    end

    class SelectableAttrMock1 < EnumBase
      selectable_attr :attr1, :default => 2 do
        i18n_scope(:selectable_attrs, :enum1)
        entry 1, :entry1, "エントリ1"
        entry 2, :entry2, "エントリ2"
        entry 3, :entry3, "エントリ3"
      end
    end

    it 'test_attr1_i18n' do
      I18n.default_locale = 'ja'
      I18n.locale = nil
      if ActiveRecord::VERSION::STRING <= "2.2.3"
        I18n.locale.should == 'ja'
      else
        I18n.locale.should == :ja
      end
      SelectableAttrMock1.attr1_name_by_key(:entry1).should == "エントリ壱"
      SelectableAttrMock1.attr1_name_by_key(:entry2).should == "エントリ弐"
      SelectableAttrMock1.attr1_name_by_key(:entry3).should == "エントリ参"
      SelectableAttrMock1.attr1_options.should == [["エントリ壱",1], ["エントリ弐",2], ["エントリ参",3]]

      I18n.locale = 'ja'
      SelectableAttrMock1.attr1_name_by_key(:entry1).should == "エントリ壱"
      SelectableAttrMock1.attr1_name_by_key(:entry2).should == "エントリ弐"
      SelectableAttrMock1.attr1_name_by_key(:entry3).should == "エントリ参"
      SelectableAttrMock1.attr1_options.should == [["エントリ壱",1], ["エントリ弐",2], ["エントリ参",3]]

      I18n.locale = 'en'
      SelectableAttrMock1.attr1_name_by_key(:entry1).should == "entry one"
      SelectableAttrMock1.attr1_name_by_key(:entry2).should == "entry two"
      SelectableAttrMock1.attr1_name_by_key(:entry3).should == "entry three"
      SelectableAttrMock1.attr1_options.should == [["entry one",1], ["entry two",2], ["entry three",3]]
    end

    class SelectableAttrMock2 < EnumBase
      selectable_attr :enum1, :default => 2 do
        i18n_scope(:selectable_attrs, :enum1)
        entry 1, :entry1, "エントリ1"
        entry 2, :entry2, "エントリ2"
        entry 3, :entry3, "エントリ3"
      end
    end

    it 'test_enum1_i18n' do
      I18n.default_locale = 'ja'
      I18n.locale = nil
      if ActiveRecord::VERSION::STRING <= "2.2.3"
        I18n.locale.should == 'ja'
      else
        I18n.locale.should == :ja
      end
      SelectableAttrMock2.enum1_name_by_key(:entry1).should == "エントリ壱"
      SelectableAttrMock2.enum1_name_by_key(:entry2).should == "エントリ弐"
      SelectableAttrMock2.enum1_name_by_key(:entry3).should == "エントリ参"
      SelectableAttrMock2.enum1_options.should == [["エントリ壱",1], ["エントリ弐",2], ["エントリ参",3]]

      I18n.locale = 'ja'
      SelectableAttrMock2.enum1_name_by_key(:entry1).should == "エントリ壱"
      SelectableAttrMock2.enum1_name_by_key(:entry2).should == "エントリ弐"
      SelectableAttrMock2.enum1_name_by_key(:entry3).should == "エントリ参"
      SelectableAttrMock2.enum1_options.should == [["エントリ壱",1], ["エントリ弐",2], ["エントリ参",3]]

      I18n.locale = 'en'
      SelectableAttrMock2.enum1_name_by_key(:entry1).should == "entry one"
      SelectableAttrMock2.enum1_name_by_key(:entry2).should == "entry two"
      SelectableAttrMock2.enum1_name_by_key(:entry3).should == "entry three"
      SelectableAttrMock2.enum1_options.should == [["entry one",1], ["entry two",2], ["entry three",3]]
    end

    # i18n用のlocaleカラムを持つselectable_attrのエントリ名をDB上に保持するためのモデル
    class I18nItemMaster < ActiveRecord::Base
    end

    # selectable_attrを使った場合その3
    # アクセス時に毎回アクセス時にDBから項目名を取得します。
    # 対象となる項目名はi18n対応している名称です
    class ProductWithI18nDB1 < ActiveRecord::Base
      set_table_name 'products'
      selectable_attr :product_type_cd do
        # update_byメソッドには、エントリのidと名称を返すSELECT文を指定する代わりに、
        # エントリのidと名称の配列の配列を返すブロックを指定することも可能です。
        update_by(:when => :everytime) do
          records = I18nItemMaster.find(:all,
            :conditions => [
              "category_name = 'product_type_cd' and locale = ? ", I18n.locale.to_s],
            :order => "item_no")
          records.map{|r| [r.item_cd, r.name]}
        end
        entry '01', :book, '書籍', :discount => 0.8
        entry '02', :dvd, 'DVD', :discount => 0.2
        entry '03', :cd, 'CD', :discount => 0.5
        entry '09', :other, 'その他', :discount => 1
      end

    end

    it "test_update_entry_name_with_i18n" do
      I18n.locale = 'ja'
      # DBに全くデータがなくてもコードで記述してあるエントリは存在します。
      I18nItemMaster.delete_all("category_name = 'product_type_cd'")
      ProductWithI18nDB1.product_type_entries.length.should      == 4
      ProductWithI18nDB1.product_type_name_by_key(:book).should  == '書籍'
      ProductWithI18nDB1.product_type_name_by_key(:dvd).should   == 'DVD'
      ProductWithI18nDB1.product_type_name_by_key(:cd).should    == 'CD'
      ProductWithI18nDB1.product_type_name_by_key(:other).should == 'その他'

      ProductWithI18nDB1.product_type_hash_array.should == [
        {:id => '01', :key => :book, :name => '書籍', :discount => 0.8},
        {:id => '02', :key => :dvd, :name => 'DVD', :discount => 0.2},
        {:id => '03', :key => :cd, :name => 'CD', :discount => 0.5},
        {:id => '09', :key => :other, :name => 'その他', :discount => 1},
      ]

      # DBからエントリの名称を動的に変更できます
      item_book = I18nItemMaster.create(:locale => 'ja', :category_name => 'product_type_cd', :item_no => 1, :item_cd => '01', :name => '本')
      ProductWithI18nDB1.product_type_entries.length.should == 4
      ProductWithI18nDB1.product_type_name_by_key(:book).should == '本'
      ProductWithI18nDB1.product_type_name_by_key(:dvd).should == 'DVD'
      ProductWithI18nDB1.product_type_name_by_key(:cd).should == 'CD'
      ProductWithI18nDB1.product_type_name_by_key(:other).should == 'その他'
      ProductWithI18nDB1.product_type_options.should == [['本', '01'], ['DVD', '02'], ['CD', '03'], ['その他', '09']]

      ProductWithI18nDB1.product_type_hash_array.should == [
        {:id => '01', :key => :book, :name => '本', :discount => 0.8},
        {:id => '02', :key => :dvd, :name => 'DVD', :discount => 0.2},
        {:id => '03', :key => :cd, :name => 'CD', :discount => 0.5},
        {:id => '09', :key => :other, :name => 'その他', :discount => 1},
      ]

      # DBからエントリの並び順を動的に変更できます
      item_book.item_no = 4;
      item_book.save!
      item_other = I18nItemMaster.create(:locale => 'ja', :category_name => 'product_type_cd', :item_no => 1, :item_cd => '09', :name => 'その他')
      item_dvd = I18nItemMaster.create(:locale => 'ja', :category_name => 'product_type_cd', :item_no => 2, :item_cd => '02') # nameは指定しなかったらデフォルトが使われます。
      item_cd = I18nItemMaster.create(:locale => 'ja', :category_name => 'product_type_cd', :item_no => 3, :item_cd => '03') # nameは指定しなかったらデフォルトが使われます。
      ProductWithI18nDB1.product_type_options.should == [['その他', '09'], ['DVD', '02'], ['CD', '03'], ['本', '01']]

      # DBからエントリを動的に追加することも可能です。
      item_toys = I18nItemMaster.create(:locale => 'ja', :category_name => 'product_type_cd', :item_no => 5, :item_cd => '04', :name => 'おもちゃ')
      ProductWithI18nDB1.product_type_options.should == [['その他', '09'], ['DVD', '02'], ['CD', '03'], ['本', '01'], ['おもちゃ', '04']]
      ProductWithI18nDB1.product_type_key_by_id('04').should == :entry_04

      ProductWithI18nDB1.product_type_hash_array.should == [
        {:id => '09', :key => :other, :name => 'その他', :discount => 1},
        {:id => '02', :key => :dvd, :name => 'DVD', :discount => 0.2},
        {:id => '03', :key => :cd, :name => 'CD', :discount => 0.5},
        {:id => '01', :key => :book, :name => '本', :discount => 0.8},
        {:id => '04', :key => :entry_04, :name => 'おもちゃ'}
      ]


      # 英語名を登録
      item_book = I18nItemMaster.create(:locale => 'en', :category_name => 'product_type_cd', :item_no => 4, :item_cd => '01', :name => 'Book')
      item_other = I18nItemMaster.create(:locale => 'en', :category_name => 'product_type_cd', :item_no => 1, :item_cd => '09', :name => 'Others')
      item_dvd = I18nItemMaster.create(:locale => 'en', :category_name => 'product_type_cd', :item_no => 2, :item_cd => '02', :name => 'DVD')
      item_cd = I18nItemMaster.create(:locale => 'en', :category_name => 'product_type_cd', :item_no => 3, :item_cd => '03', :name => 'CD')
      item_toys = I18nItemMaster.create(:locale => 'en', :category_name => 'product_type_cd', :item_no => 5, :item_cd => '04', :name => 'Toy')

      # 英語名が登録されていてもI18n.localeが変わらなければ、日本語のまま
      ProductWithI18nDB1.product_type_options.should == [['その他', '09'], ['DVD', '02'], ['CD', '03'], ['本', '01'], ['おもちゃ', '04']]
      ProductWithI18nDB1.product_type_key_by_id('04').should == :entry_04

      ProductWithI18nDB1.product_type_hash_array.should == [
        {:id => '09', :key => :other, :name => 'その他', :discount => 1},
        {:id => '02', :key => :dvd, :name => 'DVD', :discount => 0.2},
        {:id => '03', :key => :cd, :name => 'CD', :discount => 0.5},
        {:id => '01', :key => :book, :name => '本', :discount => 0.8},
        {:id => '04', :key => :entry_04, :name => 'おもちゃ'}
      ]

      # I18n.localeを変更すると取得できるエントリの名称も変わります
      I18n.locale = 'en'
      ProductWithI18nDB1.product_type_options.should == [['Others', '09'], ['DVD', '02'], ['CD', '03'], ['Book', '01'], ['Toy', '04']]
      ProductWithI18nDB1.product_type_key_by_id('04').should == :entry_04

      ProductWithI18nDB1.product_type_hash_array.should == [
        {:id => '09', :key => :other, :name => 'Others', :discount => 1},
        {:id => '02', :key => :dvd, :name => 'DVD', :discount => 0.2},
        {:id => '03', :key => :cd, :name => 'CD', :discount => 0.5},
        {:id => '01', :key => :book, :name => 'Book', :discount => 0.8},
        {:id => '04', :key => :entry_04, :name => 'Toy'}
      ]

      I18n.locale = 'ja'
      ProductWithI18nDB1.product_type_options.should == [['その他', '09'], ['DVD', '02'], ['CD', '03'], ['本', '01'], ['おもちゃ', '04']]
      ProductWithI18nDB1.product_type_key_by_id('04').should == :entry_04

      I18n.locale = 'en'
      ProductWithI18nDB1.product_type_options.should == [['Others', '09'], ['DVD', '02'], ['CD', '03'], ['Book', '01'], ['Toy', '04']]
      ProductWithI18nDB1.product_type_key_by_id('04').should == :entry_04

      # DBからレコードを削除してもコードで定義したentryは削除されません。
      # 順番はDBからの取得順で並び替えられたものの後になります
      item_dvd.destroy
      ProductWithI18nDB1.product_type_options.should == [['Others', '09'], ['CD', '03'], ['Book', '01'], ['Toy', '04'], ['DVD', '02']]

      # DB上で追加したレコードを削除すると、エントリも削除されます
      item_toys.destroy
      ProductWithI18nDB1.product_type_options.should == [['Others', '09'], ['CD', '03'], ['Book', '01'], ['DVD', '02']]

      # 名称を指定していたDBのレコードを削除したら元に戻ります。
      item_book.destroy
      ProductWithI18nDB1.product_type_options.should == [['Others', '09'], ['CD', '03'], ['書籍', '01'], ['DVD', '02']]

      # エントリに該当するレコードを全部削除したら、元に戻ります。
      I18nItemMaster.delete_all("category_name = 'product_type_cd'")
      ProductWithI18nDB1.product_type_options.should == [['書籍', '01'], ['DVD', '02'], ['CD', '03'], ['その他', '09']]
    end

    it 'test_i18n_export' do
      io = StringIO.new
      SelectableAttrRails.logger = Logger.new(io)

      I18nItemMaster.delete_all("category_name = 'product_type_cd'")

      I18n.locale = 'ja'
      actual = SelectableAttr::Enum.i18n_export
      actual.keys.should == ['selectable_attrs']
      actual['selectable_attrs'].keys.include?('enum1').should == true
      actual['selectable_attrs']['enum1'].should ==
        {'entry1'=>"エントリ壱",
         'entry2'=>"エントリ弐",
         'entry3'=>"エントリ参"}

      actual['selectable_attrs']['ProductWithI18nDB1'].should ==
        {'product_type_cd'=>
          {'book'=>"書籍", 'dvd'=>"DVD", 'cd'=>"CD", 'other'=>"その他"}}

      I18nItemMaster.create(:locale => 'en', :category_name => 'product_type_cd', :item_no => 1, :item_cd => '09', :name => 'Others')
      I18nItemMaster.create(:locale => 'en', :category_name => 'product_type_cd', :item_no => 2, :item_cd => '02', :name => 'DVD')
      I18nItemMaster.create(:locale => 'en', :category_name => 'product_type_cd', :item_no => 3, :item_cd => '03', :name => 'CD')
      I18nItemMaster.create(:locale => 'en', :category_name => 'product_type_cd', :item_no => 4, :item_cd => '01', :name => 'Book')
      I18nItemMaster.create(:locale => 'en', :category_name => 'product_type_cd', :item_no => 5, :item_cd => '04', :name => 'Toy')

      I18n.locale = 'en'
      actual = SelectableAttr::Enum.i18n_export
      actual.keys.should == ['selectable_attrs']
      actual['selectable_attrs'].keys.include?('enum1').should == true
      actual['selectable_attrs']['enum1'].should ==
        {'entry1'=>"entry one",
         'entry2'=>"entry two",
         'entry3'=>"entry three"}
      actual['selectable_attrs'].keys.should include('ProductWithI18nDB1')
      actual['selectable_attrs']['ProductWithI18nDB1'].should ==
        {'product_type_cd'=>
          {'book'=>"Book", 'dvd'=>"DVD", 'cd'=>"CD", 'other'=>"Others", 'entry_04'=>"Toy"}}
    end

    Enum2 = SelectableAttr::Enum.new do
      entry 1, :entry1, "縁鳥1"
      entry 2, :entry2, "縁鳥2"
      entry 3, :entry3, "縁鳥3"
    end

    it "i18n_scope missing" do
      io = StringIO.new
      SelectableAttrRails.logger = Logger.new(io)
      actual = SelectableAttr::Enum.i18n_export([Enum2])
      actual.inspect.should_not =~ /縁鳥/
      io.rewind
      io.readline.should =~ /^no\ i18n_scope\ of\ /
    end
  end
else
  $stderr.puts "WARNING! i18n test skipeed because I18n not found"
end
