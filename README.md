# SelectableAttrRails [![Build Status](https://secure.travis-ci.org/akm/selectable_attr_rails.png)](http://travis-ci.org/akm/selectable_attr_rails)

## Introduction
selectable_attr_railsは、selectable_attrをRailsで使うときに便利なヘルパーメソッドを提供し、
エントリをDBから取得したり、I18n対応するものです。
http://github.com/akm/selectable_attr_rails/tree/master

selectable_attr は、コードが割り振られるような特定の属性について*コード*、*プログラム上での名前*、
*表示するための名前*などをまとめて管理するものです。
http://github.com/akm/selectable_attr/tree/master


## Install
### a. plugin install
 ruby script/plugin install git://github.com/akm/selectable_attr.git
 ruby script/plugin install git://github.com/akm/selectable_attr_rails.git

### b. gem install
    [sudo] gem install selectable_attr_rails

config/initializers/selectable_attr.rb
    require 'selectable_attr'
    require 'selectable_attr_i18n'
    require 'selectable_attr_rails'
    SelectableAttrRails.setup


## チュートリアル

### selectヘルパーメソッド
以下のようなモデルが定義してあった場合
    class Person < ActiveRecord::Base
      include ::SelectableAttr::Base
      
      selectable_attr :gender do
        entry '1', :male, '男性'
        entry '2', :female, '女性'
        entry '9', :other, 'その他'
      end
    end

ビューでは以下のように選択肢を表示することができます。
    <% form_for(:person) do |f| %>
      <%= f.select :gender %>
    <% end %>

form_for、fields_forを使用しない場合でも、オブジェクト名を設定して使用可能です。
    <%= select :person, :gender %>

また以下のように複数の値を取りうる場合にもこのメソドを使用することが可能です。
    class RoomSearch
      include ::SelectableAttr::Base
      
      multi_selectable_attr :room_type do
        entry '01', :single, 'シングル'
        entry '02', :twin, 'ツイン'
        entry '03', :double, 'ダブル'
        entry '04', :triple, 'トリプル'
      end
    end
    
    <% form_for(:room_search) do |f| %>
      <%= f.select :room_type %>
    <% end %>

この場合、出力されるselectタグのmultiple属性が設定されます。



### radio_button_groupヘルパーメソッド
 一つだけ値を選択するUIの場合、selectメソッドではなく<input type="radio".../>を出力することも可能です。
 上記Personモデルの場合

    <% form_for(:person) do |f| %>
      <%= f.radio_button_group :gender %>
    <% end %>

 この場合、<input type="radio" .../><label for="xxx">... という風に続けて出力されるので、改行などを出力したい場合は
 引数を一つ取るブロックを渡して以下のように記述します。
  
    <% form_for(:person) do |f| %>
      <% f.radio_button_group :gender do |b| %>
        <% b.each do %>
          <%= b.radio_button %>
          <%= b.label %>
          <br/>
        <% end %>
      <% end %>
    <% end %>

f.radio_button_groupを呼び出しているERBのタグが、<%= %>から<% %>に変わっていることにご注意ください。


### check_box_groupヘルパーメソッド
 複数の値を選択するUIの場合、selectメソッドではなく<input type="checkbox".../>を出力することも可能です。
 上記RoomSearchクラスの場合

    <% form_for(:room_search) do |f| %>
      <%= f.check_box_group :room_type %>
    <% end %>

 この場合、<input type="checkbox" .../><label for="xxx">... という風に続けて出力されるので、改行などを出力したい場合は
 引数を一つ取るブロックを渡して以下のように記述します。
  
    <% form_for(:person) do |f| %>
      <% f.check_box_group :gender do |b| %>
        <% b.each do %>
          <%= b.check_box %>
          <%= b.label %>
          <br/>
        <% end %>
      <% end %>
    <% end %>

 f.check_box_groupを呼び出しているERBのタグが、<%= %>から<% %>に変わっていることにご注意ください。


## DBからのエントリの更新／追加
各エントリの名称を実行時に変更したり、項目を追加することが可能です。

    class RoomPlan < ActiveRecord::Base
      include ::SelectableAttr::Base
      
      selectable_attr :room_type do
        update_by "select room_type, name from room_types"
        entry '01', :single, 'シングル'
        entry '02', :twin, 'ツイン'
        entry '03', :double, 'ダブル'
        entry '04', :triple, 'トリプル'
      end
    end

というモデルと

     create_table "room_types" do |t|
       t.string   "room_type", :limit => 2
       t.string   "name", :limit => 20
     end

というマイグレーションで作成されるテーブルがあったとします。

### エントリの追加
room_typeが"05"、nameが"４ベッド"というレコードがINSERTされた後、
RoomPlan#room_type_optionsなどのselectable_attrが提供するメソッドで
各エントリへアクセスすると、update_byで指定されたSELECT文が実行され、
エントリとしては、
     entry '05', :entry_05, '４ベッド'
が定義されている状態と同じようになります。

このようにコードで定義されていないエントリは、DELETEされると、エントリもなくなります。

### エントリの名称の更新
実行時に名称を変えたい場合には、そのidに該当するレコードを追加／更新します。
例えば、
room_typeが"04"、nameが"３ベッド"というレコードがINSERTされると、その後は
04のエントリはの名称は"３ベッド"に変わり、また別の名称にUPDATEすると、それに
よってエントリの名称も変わります。

このようにコードによってエントリが定義されている場合は、DELETEされてもエントリは削除されず、
DELETE後は、名称が元に戻ります。 


## I18n対応
エントリのロケールにおける名称をRails2.2からの機能である、I18nを内部的にしようして取得できます。

上記RoomPlanモデルの場合、

config/locales/ja.yml
    ja:
      selectable_attrs:
        room_types:
          single: シングル
          twin: ツイン
          double: ダブル
          triple: トリプル
      
config/locales/en.yml
    en:
      selectable_attrs:
        room_types:
          single: Single
          twin: Twin
          double: Double
          triple: Triple
      
というYAMLを用意した上で、モデルを以下のように記述します。

    class RoomPlan < ActiveRecord::Base
      include ::SelectableAttr::Base
      
      selectable_attr :room_type do
        i18n_scope(:selectable_attrs, :room_types)
        entry '01', :single, 'シングル'
        entry '02', :twin, 'ツイン'
        entry '03', :double, 'ダブル'
        entry '04', :triple, 'トリプル'
      end
    end

これで、I18n.localeに設定されているロケールに従って各エントリの名称が変わります。


## Credit
Copyright (c) 2008 Takeshi AKIMA, released under the MIT lice nse
