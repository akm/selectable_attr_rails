# -*- coding: utf-8 -*-
require File.expand_path('spec_helper', File.dirname(__FILE__))

describe SelectableAttr do

  def assert_product_discount(klass)
    # productsテーブルのデータから安売り用の価格は
    # product_type_cd毎に決められた割合をpriceにかけて求めます。
    p1 = klass.new(:name => '実践Rails', :product_type_cd => '01', :price => 3000)
    p1.discount_price.should == 2400
    p2 = klass.new(:name => '薔薇の名前', :product_type_cd => '02', :price => 1500)
    p2.discount_price.should == 300
    p3 = klass.new(:name => '未来派野郎', :product_type_cd => '03', :price => 3000)
    p3.discount_price.should == 1500
  end
  
  # 定数をガンガン定義した場合
  # 大文字が多くて読みにくいし、関連するデータ(ここではDISCOUNT)が増える毎に定数も増えていきます。
  class LegacyProduct1 < ActiveRecord::Base
    set_table_name 'products'
    
    PRODUCT_TYPE_BOOK = '01'
    PRODUCT_TYPE_DVD = '02'
    PRODUCT_TYPE_CD = '03'
    PRODUCT_TYPE_OTHER = '09'
    
    PRODUCT_TYPE_OPTIONS = [
      ['書籍', PRODUCT_TYPE_BOOK],
      ['DVD', PRODUCT_TYPE_DVD],
      ['CD', PRODUCT_TYPE_CD],
      ['その他', PRODUCT_TYPE_OTHER]
    ]
    
    DISCOUNT = { 
      PRODUCT_TYPE_BOOK => 0.8,
      PRODUCT_TYPE_DVD => 0.2,
      PRODUCT_TYPE_CD => 0.5,
      PRODUCT_TYPE_OTHER => 1
    }
    
    def discount_price
      (DISCOUNT[product_type_cd] * price).to_i
    end
  end
  
  it "test_legacy_product" do
    assert_product_discount(LegacyProduct1)
    
    # 選択肢を表示するためのデータは以下のように取得できる
    LegacyProduct1::PRODUCT_TYPE_OPTIONS.should ==
      [['書籍', '01'], ['DVD', '02'], ['CD', '03'], ['その他', '09']]
  end
  
  
  
  
  # できるだけ定数定義をまとめた場合
  # 結構すっきりするけど、同じことをいろんなモデルで書くかと思うと気が重い。
  class LegacyProduct2 < ActiveRecord::Base
    set_table_name 'products'
    
    PRODUCT_TYPE_DEFS = [
      {:id => '01', :name => '書籍', :discount => 0.8},
      {:id => '02', :name => 'DVD', :discount => 0.2},
      {:id => '03', :name => 'CD', :discount => 0.5},
      {:id => '09', :name => 'その他', :discount => 1}
    ]
    
    PRODUCT_TYPE_OPTIONS = PRODUCT_TYPE_DEFS.map{|t| [t[:name], t[:id]]}
    DISCOUNT = PRODUCT_TYPE_DEFS.inject({}){|dest, t| 
      dest[t[:id]] = t[:discount]; dest}
      
    def discount_price
      (DISCOUNT[product_type_cd] * price).to_i
    end
  end
  
  it "test_legacy_product" do
    assert_product_discount(LegacyProduct2)
    
    # 選択肢を表示するためのデータは以下のように取得できる
    LegacyProduct2::PRODUCT_TYPE_OPTIONS.should == 
      [['書籍', '01'], ['DVD', '02'], ['CD', '03'], ['その他', '09']]
  end
  
  # selectable_attrを使った場合
  # 定義は一カ所にまとめられて、任意の属性(ここでは:discount)も一緒に書くことができてすっきり〜
  class Product1 < ActiveRecord::Base
    set_table_name 'products'
    
    selectable_attr :product_type_cd do
      entry '01', :book, '書籍', :discount => 0.8
      entry '02', :dvd, 'DVD', :discount => 0.2
      entry '03', :cd, 'CD', :discount => 0.5
      entry '09', :other, 'その他', :discount => 1
      validates_format :allow_nil => true, :message => 'は次のいずれかでなければなりません。 #{entries}'
    end

    def discount_price
      (product_type_entry[:discount] * price).to_i
    end
  end
  
  it "test_product1" do
    assert_product_discount(Product1)
    # 選択肢を表示するためのデータは以下のように取得できる
    Product1.product_type_options.should ==
      [['書籍', '01'], ['DVD', '02'], ['CD', '03'], ['その他', '09']]
  end
  
  
  # selectable_attrが定義するインスタンスメソッドの詳細
  it "test_product_type_instance_methods" do
    p1 = Product1.new
    p1.product_type_cd.should be_nil
    p1.product_type_key.should be_nil
    p1.product_type_name.should be_nil
    # idを変更すると得られるキーも名称も変わります
    p1.product_type_cd = '02'
    p1.product_type_cd.should ==   '02' 
    p1.product_type_key.should ==  :dvd 
    p1.product_type_name.should == 'DVD'
    # キーを変更すると得られるidも名称も変わります
    p1.product_type_key = :book
    p1.product_type_cd.should ==   '01'
    p1.product_type_key.should ==  :book 
    p1.product_type_name.should == '書籍'
    # id、キー、名称以外の任意の属性は、entryの[]メソッドで取得します。
    p1.product_type_key = :cd
    p1.product_type_entry[:discount].should == 0.5
  end
  
  # selectable_attrが定義するクラスメソッドの詳細
  it "test_product_type_class_methods" do
    # キーからid、名称を取得できます
    Product1.product_type_id_by_key(:book).should == '01'
    Product1.product_type_id_by_key(:dvd).should == '02'
    Product1.product_type_id_by_key(:cd).should == '03'
    Product1.product_type_id_by_key(:other).should == '09'
    Product1.product_type_name_by_key(:book).should == '書籍'
    Product1.product_type_name_by_key(:dvd).should == 'DVD'   
    Product1.product_type_name_by_key(:cd).should == 'CD'    
    Product1.product_type_name_by_key(:other).should == 'その他'
    # 存在しないキーの場合はnilを返します
    Product1.product_type_id_by_key(nil).should be_nil
    Product1.product_type_name_by_key(nil).should be_nil
    Product1.product_type_id_by_key(:unexist).should be_nil
    Product1.product_type_name_by_key(:unexist).should be_nil

    # idからキー、名称を取得できます
    Product1.product_type_key_by_id('01').should == :book
    Product1.product_type_key_by_id('02').should == :dvd
    Product1.product_type_key_by_id('03').should == :cd
    Product1.product_type_key_by_id('09').should == :other
    Product1.product_type_name_by_id('01').should == '書籍'
    Product1.product_type_name_by_id('02').should == 'DVD'
    Product1.product_type_name_by_id('03').should == 'CD'
    Product1.product_type_name_by_id('09').should == 'その他'
    # 存在しないidの場合はnilを返します
    Product1.product_type_key_by_id(nil).should be_nil
    Product1.product_type_name_by_id(nil).should be_nil
    Product1.product_type_key_by_id('99').should be_nil
    Product1.product_type_name_by_id('99').should be_nil
    
    # id、キー、名称の配列を取得できます
    Product1.product_type_ids.should == ['01', '02', '03', '09']
    Product1.product_type_keys.should == [:book, :dvd, :cd, :other]
    Product1.product_type_names.should == ['書籍', 'DVD', 'CD', 'その他']
    # 一部のものだけ取得することも可能です。
    Product1.product_type_ids(:cd, :dvd).should == ['03', '02' ]
    Product1.product_type_keys('02', '03').should == [:dvd, :cd  ]
    Product1.product_type_names('02', '03').should == ['DVD', 'CD'] 
    Product1.product_type_names(:cd, :dvd).should == ['CD', 'DVD']
    
    # select_tagなどのoption_tagsを作るための配列なんか一発っす
    Product1.product_type_options.should == 
      [['書籍', '01'], ['DVD', '02'], ['CD', '03'], ['その他', '09']]
  end

  it "validate with entries" do
    p1 = Product1.new
    p1.product_type_cd.should == nil
    p1.valid?.should == true
    p1.errors.empty?.should == true

    p1.product_type_key = :book 
    p1.product_type_cd.should == '01'
    p1.valid?.should == true
    p1.errors.empty?.should == true

    p1.product_type_cd = 'XX' 
    p1.product_type_cd.should == 'XX'
    p1.valid?.should == false
    p1.errors.on(:product_type_cd).should == "は次のいずれかでなければなりません。 書籍, DVD, CD, その他"
  end

  # selectable_attrのエントリ名をDB上に保持するためのモデル
  class ItemMaster < ActiveRecord::Base
  end
  
  # selectable_attrを使った場合その２
  # アクセス時に毎回アクセス時にDBから項目名を取得します。
  class ProductWithDB1 < ActiveRecord::Base
    set_table_name 'products'
    
    selectable_attr :product_type_cd do
      update_by(
        "select item_cd, name from item_masters where category_name = 'product_type_cd' order by item_no", 
        :when => :everytime)
      entry '01', :book, '書籍', :discount => 0.8
      entry '02', :dvd, 'DVD', :discount => 0.2
      entry '03', :cd, 'CD', :discount => 0.5
      entry '09', :other, 'その他', :discount => 1
    end

    def discount_price
      (product_type_entry[:discount] * price).to_i
    end
  end
  
  it "test_update_entry_name" do
    # DBに全くデータがなくてもコードで記述してあるエントリは存在します。
    ItemMaster.delete_all("category_name = 'product_type_cd'")
    ProductWithDB1.product_type_entries.length.should == 4
    ProductWithDB1.product_type_name_by_key(:book).should == '書籍'
    ProductWithDB1.product_type_name_by_key(:dvd).should == 'DVD'
    ProductWithDB1.product_type_name_by_key(:cd).should == 'CD'
    ProductWithDB1.product_type_name_by_key(:other).should == 'その他'

    assert_product_discount(ProductWithDB1)
    
    # DBからエントリの名称を動的に変更できます
    item_book = ItemMaster.create(:category_name => 'product_type_cd', :item_no => 1, :item_cd => '01', :name => '本')
    ProductWithDB1.product_type_entries.length.should == 4
    ProductWithDB1.product_type_name_by_key(:book).should == '本'    
    ProductWithDB1.product_type_name_by_key(:dvd).should == 'DVD'   
    ProductWithDB1.product_type_name_by_key(:cd).should == 'CD'    
    ProductWithDB1.product_type_name_by_key(:other).should == 'その他' 
    ProductWithDB1.product_type_options.should == 
      [['本', '01'], ['DVD', '02'], ['CD', '03'], ['その他', '09']]
    
    # DBからエントリの並び順を動的に変更できます
    item_book.item_no = 4;
    item_book.save!
    item_other = ItemMaster.create(:category_name => 'product_type_cd', :item_no => 1, :item_cd => '09', :name => 'その他')
    item_dvd = ItemMaster.create(:category_name => 'product_type_cd', :item_no => 2, :item_cd => '02') # nameは指定しなかったらデフォルトが使われます。
    item_cd = ItemMaster.create(:category_name => 'product_type_cd', :item_no => 3, :item_cd => '03') # nameは指定しなかったらデフォルトが使われます。
    ProductWithDB1.product_type_options.should ==
      [['その他', '09'], ['DVD', '02'], ['CD', '03'], ['本', '01']]
    
    # DBからエントリを動的に追加することも可能です。
    item_toys = ItemMaster.create(:category_name => 'product_type_cd', :item_no => 5, :item_cd => '04', :name => 'おもちゃ')
    ProductWithDB1.product_type_options.should == 
      [['その他', '09'], ['DVD', '02'], ['CD', '03'], ['本', '01'], ['おもちゃ', '04']]
    ProductWithDB1.product_type_key_by_id('04').should == :entry_04
    
    # DBからレコードを削除してもコードで定義したentryは削除されません。
    # 順番はDBからの取得順で並び替えられたものの後になります
    item_dvd.destroy
    ProductWithDB1.product_type_options.should == 
      [['その他', '09'], ['CD', '03'], ['本', '01'], ['おもちゃ', '04'], ['DVD', '02']]
    
    # DB上で追加したレコードを削除すると、エントリも削除されます
    item_toys.destroy
    ProductWithDB1.product_type_options.should == 
      [['その他', '09'], ['CD', '03'], ['本', '01'], ['DVD', '02']]
    
    # 名称を指定していたDBのレコードを削除したら元に戻ります。
    item_book.destroy
    ProductWithDB1.product_type_options.should == 
      [['その他', '09'], ['CD', '03'], ['書籍', '01'], ['DVD', '02']]
    
    # エントリに該当するレコードを全部削除したら、元に戻ります。
    ItemMaster.delete_all("category_name = 'product_type_cd'")
    ProductWithDB1.product_type_options.should == 
      [['書籍', '01'], ['DVD', '02'], ['CD', '03'], ['その他', '09']]
    
    assert_product_discount(ProductWithDB1)
  end
  
  

  
  # Q: product_type_cd の'_cd'はどこにいっちゃったの？
  # A: デフォルトでは、/(_cd$|_code$|_cds$|_codes$)/ を削除したものをbase_nameとして
  #    扱い、それに_keyなどを付加してメソッド名を定義します。もしこのルールを変更したい場合、
  #    selectable_attrを使う前に selectable_attr_name_pattern で新たなルールを指定してください。
  class Product2 < ActiveRecord::Base
    set_table_name 'products'
    self.selectable_attr_name_pattern = /^product_|_cd$/
    
    selectable_attr :product_type_cd do
      entry '01', :book, '書籍', :discount => 0.8
      entry '02', :dvd, 'DVD', :discount => 0.2
      entry '03', :cd, 'CD', :discount => 0.5
      entry '09', :other, 'その他', :discount => 1
    end

    def discount_price
      (type_entry[:discount] * price).to_i
    end
  end
  
  it "test_product2" do
    assert_product_discount(Product2)
    # 選択肢を表示するためのデータは以下のように取得できる
    Product2.type_options.should ==
      [['書籍', '01'], ['DVD', '02'], ['CD', '03'], ['その他', '09']]

    p2 = Product2.new
    p2.product_type_cd.should be_nil
    p2.type_key.should be_nil
    p2.type_name.should be_nil
    # idを変更すると得られるキーも名称も変わります
    p2.product_type_cd = '02'
    p2.product_type_cd.should == '02'
    p2.type_key.should == :dvd
    p2.type_name.should == 'DVD'
    # キーを変更すると得られるidも名称も変わります
    p2.type_key = :book
    p2.product_type_cd.should == '01'
    p2.type_key.should == :book 
    p2.type_name.should == '書籍'
    # id、キー、名称以外の任意の属性は、entryの[]メソッドで取得します。
    p2.type_key = :cd
    p2.type_entry[:discount].should == 0.5
    
    Product2.type_id_by_key(:book).should == '01'
    Product2.type_id_by_key(:dvd).should == '02'
    Product2.type_name_by_key(:cd).should == 'CD'
    Product2.type_name_by_key(:other).should == 'その他'
    Product2.type_key_by_id('09').should == :other
    Product2.type_name_by_id('01').should == '書籍'
    Product2.type_keys.should == [:book, :dvd, :cd, :other]
    Product2.type_names.should == ['書籍', 'DVD', 'CD', 'その他']
    Product2.type_keys('02', '03').should == [:dvd, :cd]
    Product2.type_names(:cd, :dvd).should == ['CD', 'DVD']
  end
  
  
  
  
  # Q: selectable_attrの呼び出し毎にbase_bname(って言うの？)を指定したいんだけど。
  # A: base_nameオプションを指定してください。
  class Product3 < ActiveRecord::Base
    set_table_name 'products'
    
    selectable_attr :product_type_cd, :base_name => 'type' do
      entry '01', :book, '書籍', :discount => 0.8
      entry '02', :dvd, 'DVD', :discount => 0.2
      entry '03', :cd, 'CD', :discount => 0.5
      entry '09', :other, 'その他', :discount => 1
    end

    def discount_price
      (type_entry[:discount] * price).to_i
    end
  end
  
  it "test_product3" do 
    assert_product_discount(Product3)
    # 選択肢を表示するためのデータは以下のように取得できる
    Product3.type_options.should ==
      [['書籍', '01'], ['DVD', '02'], ['CD', '03'], ['その他', '09']]
      
    p3 = Product3.new
    p3.product_type_cd.should be_nil
    p3.type_key.should be_nil
    p3.type_name.should be_nil
    # idを変更すると得られるキーも名称も変わります
    p3.product_type_cd = '02'
    p3.product_type_cd.should == '02'
    p3.type_key.should ==        :dvd
    p3.type_name.should ==       'DVD'
    # キーを変更すると得られるidも名称も変わります
    p3.type_key = :book
    p3.product_type_cd.should == '01'
    p3.type_key.should ==        :book
    p3.type_name.should ==       '書籍'
    # id、キー、名称以外の任意の属性は、entryの[]メソッドで取得します。
    p3.type_key = :cd
    p3.type_entry[:discount].should == 0.5
    
    Product3.type_id_by_key(:book).should ==    '01'
    Product3.type_id_by_key(:dvd).should ==     '02'    
    Product3.type_name_by_key(:cd).should ==    'CD'    
    Product3.type_name_by_key(:other).should == 'その他'
    Product3.type_key_by_id('09').should ==     :other  
    Product3.type_name_by_id('01').should ==    '書籍'  
    Product3.type_keys.should == [:book, :dvd, :cd, :other]
    Product3.type_names.should == ['書籍', 'DVD', 'CD', 'その他']
    Product3.type_keys('02', '03').should == [:dvd, :cd]
    Product3.type_names(:cd, :dvd).should == ['CD', 'DVD']
  end
  
end

