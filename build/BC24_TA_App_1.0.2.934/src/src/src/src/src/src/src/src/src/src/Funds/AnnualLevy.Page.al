page 51411 "Annual Levy"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "SASRA Annual Levy";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Levy Year"; Rec."Levy Year")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Levy Year field.';

                }
                field("Customer No"; Rec."Customer No")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Customer No field.';

                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Name field.';

                }
                field("Serial No"; Rec."Serial No")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Serial No field.';

                }
                field("Total Deposit"; Rec."Total Deposit")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Total Deposit field.';

                }
                field("Levy Computation"; Rec."Levy Computation")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Levy Computation field.';

                }
                field("Levy Capped"; Rec."Levy Capped")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Levy Capped field.';

                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Date field.';

                }
                field(Selected; Rec.Selected)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Selected field.';

                }
                field(Posted; Rec.Posted)
                {
                    caption = 'Generated';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Generated field.';

                }
                field("Invoice No"; Rec."Invoice No")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Invoice No field.';

                }
            }
        }
        area(Factboxes) { }
    }

    actions
    {
        area(Processing)
        {
            action(SelectAll)
            {
                ApplicationArea = All;
                Caption = 'Select All';
                ToolTip = 'Executes the Select All action.';
                trigger OnAction();
                var
                    LevyRec: Record "SASRA Annual Levy";
                begin
                    if Confirm('Do you really want to select all invoices?', false) then begin
                        LevyRec.reset;
                        LevyRec.setrange(Posted, false);
                        LevyRec.setrange(selected, false);
                        if LevyRec.find('-') then begin
                            repeat
                                LevyRec.Selected := true;
                                LevyRec.modify;
                            until LevyRec.next = 0;
                        end;
                    end;
                end;
            }
            action(UnSelectAll)
            {
                ApplicationArea = All;
                Caption = 'UnSelect All';
                ToolTip = 'Executes the UnSelect All action.';
                trigger OnAction();
                var
                    LevyRec: Record "SASRA Annual Levy";
                begin
                    if Confirm('Do you really want to unselect all invoices?', false) then begin
                        LevyRec.reset;
                        LevyRec.setrange(Posted, false);
                        LevyRec.setrange(selected, true);
                        if LevyRec.find('-') then begin
                            repeat
                                LevyRec.Selected := false;
                                LevyRec.modify;
                            until LevyRec.next = 0;
                        end;
                    end;
                end;
            }
            action(GenerateInv)
            {
                ApplicationArea = All;
                Caption = 'Generate Invoices';
                ToolTip = 'Executes the Generate Invoices action.';
                trigger OnAction();
                var
                    GBill: Codeunit "Gen. Jnl.-Post B";
                    Charge: Record Charge;
                    LevyRec: Record "SASRA Annual Levy";
                    Cust: record customer;
                begin
                    if Confirm('Do you really want to generate the levy invoices?', false) then begin
                        LevyRec.reset;
                        LevyRec.setrange(Posted, false);
                        LevyRec.setrange(selected, true);
                        if LevyRec.find('-') then begin
                            repeat
                                Charge.Reset;
                                Charge.setrange("Annual Charge", true);
                                if Charge.find('-') then begin
                                    if Cust.get(LevyRec."Customer No") then begin
                                        LevyRec.TestField(Date);
                                        LevyRec."Invoice No" := GBill.GenerateMassInvoice(LevyRec."Customer No", Charge.Code, LevyRec."Levy Computation", LevyRec.Date);
                                        LevyRec.Posted := true;
                                        LevyRec."Posted By" := UserId;
                                        LevyRec."Posting Date" := today;
                                        LevyRec.modify;
                                    end;
                                end;
                            until LevyRec.next = 0;
                        end;

                    end;
                end;
            }
            action(ClearInv)
            {
                ApplicationArea = All;
                Caption = 'Clear Generated Invoices';
                ToolTip = 'Executes the Clear Generated Invoices action.';
                trigger OnAction();
                var
                    LevyRec: Record "SASRA Annual Levy";
                    SaleH: record "sales header";
                    SaleLine: record "Sales Line";
                begin
                    if Confirm('Do you really want to delete generated levy invoices?', false) then begin
                        LevyRec.reset;
                        LevyRec.setrange(Posted, true);
                        if LevyRec.find('-') then begin
                            repeat
                                SaleH.reset;
                                SaleH.setrange(SaleH."Bill-to Customer No.", LevyRec."Customer No");
                                if SaleH.find('-') then
                                    SaleH.deleteall;


                                SaleLine.reset;
                                SaleLine.setrange(SaleLine."Bill-to Customer No.", LevyRec."Customer No");
                                if SaleLine.find('-') then
                                    SaleLine.deleteall;

                            until LevyRec.next = 0;
                        end;
                    end;
                end;
            }
        }
    }
}


