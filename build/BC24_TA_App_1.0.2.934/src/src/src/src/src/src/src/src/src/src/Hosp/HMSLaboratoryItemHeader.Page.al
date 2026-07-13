page 50423 "HMS Laboratory Item Header"
{
    PageType = Document;
    SourceTable = "HMS Laboratory Test Line";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1102760000)
            {
                Editable = false;
                ShowCaption = false;
                field("Laboratory No."; Rec."Laboratory No.")
                {
                    ToolTip = 'Specifies the value of the Laboratory No. field.';
                }
                field("Laboratory Test Code"; Rec."Laboratory Test Code")
                {
                    ToolTip = 'Specifies the value of the Laboratory Test Code field.';
                }
                field("Laboratory Test Name"; Rec."Laboratory Test Name")
                {
                    ToolTip = 'Specifies the value of the Laboratory Test Name field.';
                }
                field("Specimen Code"; Rec."Specimen Code")
                {
                    ToolTip = 'Specifies the value of the Specimen Code field.';
                }
                field("Specimen Name"; Rec."Specimen Name")
                {
                    ToolTip = 'Specifies the value of the Specimen Name field.';
                }
                field("Assigned User ID"; Rec."Assigned User ID")
                {
                    ToolTip = 'Specifies the value of the Assigned User ID field.';
                }
                field("Collection Date"; Rec."Collection Date")
                {
                    ToolTip = 'Specifies the value of the Collection Date field.';
                }
                field("Collection Time"; Rec."Collection Time")
                {
                    ToolTip = 'Specifies the value of the Collection Time field.';
                }
                field("Measuring Unit Code"; Rec."Measuring Unit Code")
                {
                    ToolTip = 'Specifies the value of the Measuring Unit Code field.';
                }
                field("Measuring Unit Name"; Rec."Measuring Unit Name")
                {
                    ToolTip = 'Specifies the value of the Measuring Unit Name field.';
                }
            }
            part(Control1102760028; "HMS Laboratory Item Subform")
            {
                SubPageLink = "Laboratory No." = FIELD("Laboratory No."),
                              "Laboratory Test Code" = FIELD("Laboratory Test Code"),
                              "Specimen Code" = FIELD("Specimen Code");
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("&Post Item Usage")
            {
                Caption = '&Post Item Usage';
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Executes the &Post Item Usage action.';

                trigger OnAction()
                begin
                    if Confirm('Do you wish to post the record?', false) = false then begin exit end;
                    HMSSetup.Reset;
                    HMSSetup.Get();
                    ItemJnlLine.Reset;
                    ItemJnlLine.SetRange(ItemJnlLine."Journal Template Name", HMSSetup."Laboratory Item Journal Temp");
                    ItemJnlLine.SetRange(ItemJnlLine."Journal Batch Name", HMSSetup."Laboratory Item Journal Batch");
                    if ItemJnlLine.Find('-') then ItemJnlLine.DeleteAll;
                    LineNo := 1000;
                    PharmLine.Reset;
                    PharmLine.SetRange(PharmLine."Laboratory No.", Rec."Laboratory No.");
                    //PharmLine.SETRANGE(PharmLine."Laboratory Test Package Code","Laboratory Test Package Code");
                    PharmLine.SetRange(PharmLine."Laboratory Test Code", Rec."Laboratory Test Code");
                    PharmLine.SetRange(PharmLine."Specimen Code", Rec."Specimen Code");
                    PharmLine.SetRange(PharmLine.Posted, false);
                    if PharmLine.Find('-') then begin
                        repeat
                            ItemJnlLine.Init;
                            ItemJnlLine."Journal Template Name" := HMSSetup."Laboratory Item Journal Temp";
                            ItemJnlLine."Journal Batch Name" := HMSSetup."Laboratory Item Journal Batch";
                            ItemJnlLine."Line No." := LineNo;
                            ItemJnlLine."Posting Date" := Today;
                            ItemJnlLine."Entry Type" := ItemJnlLine."Entry Type"::"Negative Adjmt.";

                            ItemJnlLine."Document No." := PharmLine."Laboratory No." + ':' + PharmLine."Item No.";
                            ItemJnlLine."Item No." := PharmLine."Item No.";
                            ItemJnlLine.Validate(ItemJnlLine."Item No.");
                            ItemJnlLine."Location Code" := HMSSetup."Laboratory Room";
                            ItemJnlLine.Validate(ItemJnlLine."Location Code");
                            ItemJnlLine.Quantity := PharmLine."Item Quantity";
                            ItemJnlLine.Validate(ItemJnlLine.Quantity);
                            ItemJnlLine."Unit of Measure Code" := PharmLine."Item Unit Of Measure";
                            ItemJnlLine.Validate(ItemJnlLine."Unit of Measure Code");
                            ItemJnlLine.Validate(ItemJnlLine."Unit Amount");
                            ItemJnlLine.Insert();
                            PharmLine.Posted := true;
                            PharmLine.Modify;
                            LineNo := LineNo + 1;
                        /*Update the treatment lines*/
                        until PharmLine.Next = 0;
                        CODEUNIT.Run(CODEUNIT::"Item Jnl.-Post Batch", ItemJnlLine);


                    end;

                end;
            }
        }
    }

    var
        HMSSetup: Record "HMS Setup";
        LineNo: Integer;
        PharmLine: Record "HMS Laboratory Item Usage";
        ItemJnlLine: Record "Item Journal Line";
}

