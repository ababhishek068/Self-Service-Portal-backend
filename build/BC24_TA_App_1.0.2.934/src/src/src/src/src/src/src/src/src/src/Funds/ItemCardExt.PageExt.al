pageextension 50018 "Item Card Ext" extends "Item Card"
{
    layout
    {
        addafter("Common Item No.")
        {
            field("Item G/L Budget Account"; Rec."Item G/L Budget Account")
            {
                ApplicationArea = basic;
                ToolTip = 'Specifies the value of the Item G/L Budget Account field.';
            }
        }
        addafter("No."){
            field("Part No";"Part No"){}
        }
        addbefore (Description){
            field("Serial No";"Serial No"){}
        }
        addafter(Description)
        {
            field(Model;Model){ApplicationArea=basic;}
            field(Brand;Brand){ApplicationArea=basic;}
        }
        addafter("Base Unit of Measure")
        {
            field("Additional Convertion Rate"; Rec."Additional Convertion Rate")
            {
                ApplicationArea = basic;
                ToolTip = 'Specifies the value of the Additional Convertion Rate field.';
            }
        }
        addafter("Item Category Code")
        {
            field("Category Name";"Category Name")
            {
                ApplicationArea = basic;
                Editable=false;

            }
            field("Item Sub-Category";"Item Sub-Category")
            {
                ApplicationArea = basic;

            }
            field("Sub-Category name";"Sub-Category name")
            {
                ApplicationArea = basic;
                Editable=false;

            }
            field("Item Coding";"Item Coding")
            {
                Editable=false;
                ApplicationArea = basic;
                }
        }
        modify(GTIN)
        {
            Visible = false;
        }

    }
    actions
    {
        addafter("Item Reclassification Journal")
        {
            action("CustomStatement")
            {
                ApplicationArea = Basic;
                Image = Print;
                Caption = 'Item Statement';
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                ToolTip = 'Executes the Item Statement action.';
                trigger OnAction()
                var
                    recItemLed: Record "Item Ledger Entry";
                begin
                    recItemLed.reset;
                    recItemLed.setfilter(recItemLed."Item No.", Rec."No.");
                    if recItemLed.find('-') then begin

                        report.run(70135660, true, true, recItemLed)

                    end;
                end;
            }
        }
        addafter("Assembly BOM")
        {
            action("External Material")
            {
                caption = 'External Materials';
                ApplicationArea = basic;
                Image = MachineCenterLoad;
                RunObject = page "Prod. Item Material";
                RunPageLink = "Item No" = field("No.");
                ToolTip = 'Executes the External Materials action.';
            }


        }
    }
    trigger OnNewRecord(BelowxRec: Boolean)
    var
        UserRec: record "User Setup";
    begin
        UserRec.Get(Database.UserId);
        UserRec.TestField("Can Create Item");

    end;
}