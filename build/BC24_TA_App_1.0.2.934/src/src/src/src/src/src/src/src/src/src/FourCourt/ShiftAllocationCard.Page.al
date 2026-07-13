page 51062 "Shift Allocation Card"
{
    PageType = Document;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Shift Allocation";

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                Caption = 'General';
                field(No; Rec.No)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No field.';
                    trigger OnAssistEdit()
                    begin
                        if Rec.AssistEdit(xRec) then
                            CurrPage.Update();
                    end;

                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Date field.';

                }
                field("Station Code"; Rec."Station Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Station Code field.';

                }
                field("Shift Type"; Rec."Shift Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Shift Type field.';

                }
                field("Special Discount"; Rec."Special Discount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Special Discount field.';

                }
                field("Special Discount Amount"; Rec."Special Discount Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Special Discount Amount field.';

                }
                field(Open; Rec.Open)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Open field.';

                }
                field("Opened By"; Rec."Opened By")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Opened By field.';

                }
                field("Opening Date"; Rec."Opening Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Opening Date field.';

                }


            }
            group(Allocations)
            {
                part(Lines; "Shift Allocation Lines")
                {
                    ApplicationArea = basic;
                    caption = 'Staff Allocation';
                    SubPageLink = No = field(No), "Station Code" = field("Station Code");
                }
            }
        }
        area(Factboxes) { }
    }

    actions
    {
        area(Processing)
        {
            action(OpenShift)
            {
                ApplicationArea = All;
                Caption = 'Open Shift';
                ToolTip = 'Executes the Open Shift action.';
                trigger OnAction();
                var
                    ShiftLines: Record "Shift Allocation Line";
                    SalesPerson: Record "Salesperson/Purchaser";
                begin
                    if Confirm('Do you really want to Open the shift?', false) then begin
                        ShiftLines.reset;
                        ShiftLines.setrange(No, Rec.No);
                        if ShiftLines.find('-') then begin
                            repeat
                                if SalesPerson.get(ShiftLines."Staff No") then begin
                                    SalesPerson.Active := true;
                                    SalesPerson."Active Shift No" := Rec.No;
                                    SalesPerson.modify;
                                end;
                                ShiftLines.open := true;
                                ShiftLines.modify;
                            until ShiftLines.next = 0;
                        end;
                        rec.Open := true;
                        Rec.Posted := false;
                        rec."Opened By" := UserId;
                        rec."Opening Date" := today;
                        rec.Modify;
                    end;
                end;
            }
            action(Post)
            {
                ApplicationArea = All;
                Caption = 'Close Shift';
                ToolTip = 'Executes the Close Shift action.';
                trigger OnAction();
                var
                    ShiftLines: Record "Shift Allocation Line";
                    SalesPerson: Record "Salesperson/Purchaser";
                begin
                    if Confirm('Do you really want to post the shift?', false) then begin
                        ShiftLines.reset;
                        ShiftLines.setrange(No, Rec.No);
                        if ShiftLines.find('-') then begin
                            repeat
                                if SalesPerson.get(ShiftLines."Staff No") then begin
                                    SalesPerson.Active := false;
                                    SalesPerson.modify;
                                end;
                                ShiftLines.Posted := true;
                                ShiftLines.open := false;
                                ShiftLines.modify;
                            until ShiftLines.next = 0;
                        end;
                        rec.Posted := true;
                        Rec.Open := false;
                        rec."Posted By" := UserId;
                        rec."Posting Date" := today;
                        rec.Modify;
                    end;
                end;
            }
        }
    }
}