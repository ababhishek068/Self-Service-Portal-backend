namespace Microsoft;

page 51488 "Tenders-List"


{
    ApplicationArea = All;
    Caption = 'Tenders List';
    PageType = list;
    SourceTable = "Purchase Quote Header";
    DeleteAllowed = false;
    CardPageId = "Tender - Card";
    PromotedActionCategories = 'New,Process,Reports,Approval';
    SourceTableView = where("Document Type" = const("Open Tender"));


    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    Caption = 'Tender No';

                }
                field("Document Type"; Rec."Document Type") { }

                field("Expected Opening Date"; Rec."Expected Opening Date") { }

                field("Expected Closing Date"; Rec."Expected Closing Date") { }
                field("Posting Description"; Rec."Posting Description") { }

                field(Status; Rec.Status) { }

            }

        }




    }
    // trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    // begin
    //     Rec."Document Type" := Rec."Document Type"::"Open Tender";
    // end;


}