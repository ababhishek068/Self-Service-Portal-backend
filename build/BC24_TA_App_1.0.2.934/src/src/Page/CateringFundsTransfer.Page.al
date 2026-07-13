Page 50856 "Catering Funds Transfer"
{
    PageType = List;
    SourceTable = "Catering Funds Transfer";
    SourceTableView = where(Posted = const(false));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(TransferType; Rec."Transfer Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Transfer Type field.';
                }
                field(StudentNo; Rec."Student No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Student No field.';
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Name field.';
                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date field.';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Amount field.';
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action(Post)
            {
                ApplicationArea = Basic;
                Image = PostDocument;
                Promoted = true;
                ToolTip = 'Executes the Post action.';

                trigger OnAction()
                begin

                    Rec.TestField(Posted, false);
                    if Confirm('Do you really want to post the selected transfer?') then begin
                        CateringSetUp.Get;
                        CateringSetUp.TestField(CateringSetUp."Catering Control Account");
                        if Rec."Transfer Type" = Rec."transfer type"::"To Catering" then begin
                            Rec.Validate(Amount);
                            JournLine.Init;
                            JournLine."Journal Template Name" := CateringSetUp."Sales Template";
                            JournLine."Journal Batch Name" := CateringSetUp."Sales Batch";
                            JournLine."Line No." := JournLine."Line No." + 1;
                            JournLine."Account Type" := JournLine."account type"::Customer;
                            JournLine."Account No." := Rec."Student No";
                            JournLine."Posting Date" := Rec.Date;
                            JournLine."Document No." := 'Transfer ' + Format(Rec."Line No");
                            JournLine.Description := 'Fees to Catering Transfer';
                            JournLine."Bal. Account No." := CateringSetUp."Catering Control Account";
                            JournLine.Amount := Rec.Amount;
                            JournLine.Insert;

                            if CLedger.FindLast then LastEntry := CLedger."Entry No";
                            CLedger.Init;
                            CLedger."Entry No" := LastEntry + 1;
                            CLedger."Customer No" := Rec."Student No";
                            CLedger."Entry Type" := CLedger."entry type"::"Debit Transfer";
                            CLedger.Date := Rec.Date;
                            CLedger.Description := 'Fees to Catering Tution';
                            CLedger.Amount := Rec.Amount;
                            CLedger."User ID" := UserId;
                            CLedger.Insert;
                        end;

                        if Rec."Transfer Type" = Rec."transfer type"::"To Fees" then begin
                            Rec.Validate(Amount);
                            JournLine.Init;
                            JournLine."Journal Template Name" := CateringSetUp."Sales Template";
                            JournLine."Journal Batch Name" := CateringSetUp."Sales Batch";
                            JournLine."Line No." := JournLine."Line No." + 1;
                            JournLine."Account Type" := JournLine."account type"::Customer;
                            JournLine."Account No." := Rec."Student No";
                            JournLine."Posting Date" := Rec.Date;
                            JournLine."Document No." := 'Transfer ' + Format(Rec."Line No");
                            JournLine.Description := 'Fees from Catering Tution';
                            JournLine."Bal. Account No." := CateringSetUp."Catering Control Account";
                            JournLine.Amount := -Rec.Amount;
                            JournLine.Insert;

                            if CLedger.FindLast then LastEntry := CLedger."Entry No";
                            CLedger.Init;
                            CLedger."Entry No" := LastEntry + 1;
                            CLedger."Customer No" := Rec."Student No";
                            CLedger."Entry Type" := CLedger."entry type"::"Credit Transfer";
                            CLedger.Date := Rec.Date;
                            CLedger.Description := 'Fees from Catering Tution';
                            CLedger.Amount := -Rec.Amount;
                            CLedger."User ID" := UserId;
                            CLedger.Insert;

                        end;


                        //Post New
                        JournLine.Reset;
                        JournLine.SetRange("Journal Template Name", CateringSetUp."Sales Template");
                        JournLine.SetRange("Journal Batch Name", CateringSetUp."Sales Batch");
                        if JournLine.Find('-') then begin
                            Codeunit.Run(Codeunit::"Gen. Jnl.-Post", JournLine);
                        end;


                        Rec.Posted := true;
                        Rec."Posted By" := UserId;
                        Rec.Modify;
                    end;
                end;
            }
            action("Update Catering Only")
            {
                ApplicationArea = Basic;
                Image = UndoShipment;
                Visible = false;
                ToolTip = 'Executes the Update Catering Only action.';

                trigger OnAction()
                begin
                    if Rec."Transfer Type" = Rec."transfer type"::"To Catering" then begin
                        if CLedger.FindLast then LastEntry := CLedger."Entry No";
                        CLedger.Init;
                        CLedger."Entry No" := LastEntry + 1;
                        CLedger."Customer No" := Rec."Student No";
                        CLedger."Entry Type" := CLedger."entry type"::"Debit Transfer";
                        CLedger.Date := Rec.Date;
                        CLedger.Description := 'Fees to Catering Tution';
                        CLedger.Amount := Rec.Amount;
                        CLedger."User ID" := UserId;
                        CLedger.Insert;
                    end;
                    if Rec."Transfer Type" = Rec."transfer type"::"To Fees" then begin
                        if CLedger.FindLast then LastEntry := CLedger."Entry No";
                        CLedger.Init;
                        CLedger."Entry No" := LastEntry + 1;
                        CLedger."Customer No" := Rec."Student No";
                        CLedger."Entry Type" := CLedger."entry type"::"Credit Transfer";
                        CLedger.Date := Rec.Date;
                        CLedger.Description := 'Fees from Catering Tution';
                        CLedger.Amount := -Rec.Amount;
                        CLedger."User ID" := UserId;
                        CLedger.Insert;
                    end;
                    Message('Catering Updated Succussfully');
                end;
            }
        }
    }

    var
        JournLine: Record "Gen. Journal Line";
        CateringSetUp: Record "Catering SetUp";
        CLedger: Record "Catering Prepayment Ledger";
        LastEntry: Integer;
}

