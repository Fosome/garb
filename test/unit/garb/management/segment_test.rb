require 'test_helper'

module Garb
  module Management
    class SegmentTest < MiniTest::Unit::TestCase
      context "The Segment class" do
        should "turn entries for path into array of accounts" do
          feed = stub(:entries => ["entry1"])
          Feed.stubs(:new).returns(feed)

          Segment.stubs(:new_from_entry)
          Segment.all

          assert_received(Feed, :new) {|e| e.with(Session, '/segments')}
          assert_received(feed, :entries)
          assert_received(Segment, :new_from_entry) {|e| e.with("entry1", Session)}
        end
      end

      context "A Segment" do
        setup do
          entry = {
            "link" => [{"rel" => "self", "href" => Feed::BASE_URL+"/segments/12"}],
            "dxp:segment" => {
              "id" => "gaid::-3",
              "name" => "Returning Visitor",
              "dxp:definition" => "ga:visitorType==Returning Visitor"
            }
          }
          @segment = Segment.new_from_entry(entry, Session)
        end

        should "have an id" do
          assert_equal "gaid::-3", @segment.id
        end

        should "have a name" do
          assert_equal "Returning Visitor", @segment.name
        end

        should "have a definition" do
          assert_equal "ga:visitorType==Returning Visitor", @segment.definition
        end
      end
    end
  end
end
