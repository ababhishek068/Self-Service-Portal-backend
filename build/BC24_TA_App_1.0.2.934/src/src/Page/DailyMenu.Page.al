Page 50737 "Daily Menu"
{
    PageType = List;
    SourceTable = "Daily Menu";
    SourceTableView = where(Posted = const(false));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            field(MenuDate; MenuDate)
            {
                ApplicationArea = Basic;
                Caption = 'Menu Date';
                ToolTip = 'Specifies the value of the Menu Date field.';

                trigger OnValidate()
                begin
                    Rec."Menu Date" := MenuDate;
                    Rec.SetRange("Menu Date", MenuDate);
                end;
            }
            repeater(Control1000000000)
            {
                field(Menu; Rec.Menu)
                {
                    ApplicationArea = Basic;
                    LookupPageID = "Menu List";
                    ToolTip = 'Specifies the value of the Menu field.';

                    trigger OnValidate()
                    begin
                        Rec."Menu Date" := MenuDate;

                        // TESTFIELD("Menu Date");
                        MenuRec.SetRange(MenuRec.Code, Rec.Menu);
                        if MenuRec.Find('-') then begin
                            Rec.Description := MenuRec.Description;
                            Rec.Units := MenuRec."Units Of Measure";
                            Rec."Menu Qty" := MenuRec.Quantity;
                            Rec."Unit Cost" := MenuRec.Amount;
                            Rec.Type := MenuRec.Type;
                        end;
                    end;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(Units; Rec.Units)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Units field.';
                }
                field(MenuQty; Rec."Menu Qty")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Menu Qty field.';
                }
                field(TotalQty; Rec."Total Qty")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Total Qty field.';
                }
                field(Yield; Rec.Yield)
                {
                    ApplicationArea = Basic;
                    Caption = 'Used Receipe';
                    ToolTip = 'Specifies the value of the Used Receipe field.';
                }
                field(ProdQty; Rec."Prod Qty")
                {
                    ApplicationArea = Basic;
                    Caption = 'Yield';
                    ToolTip = 'Specifies the value of the Yield field.';

                    trigger OnValidate()
                    begin
                        Rec."Total Qty" := Rec."Menu Qty" * Rec."Prod Qty";
                        Rec."Total Cost" := Rec."Total Qty" * Rec."Unit Cost";
                    end;
                }
                field(UnitCost; Rec."Unit Cost")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Unit Cost field.';
                }
                field(TotalCost; Rec."Total Cost")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Total Cost field.';
                }
                field(RemainingQty; Rec."Remaining Qty")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Remaining Qty field.';
                }
                field(CampusCode; Rec."Campus Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Campus Code field.';
                }
                field(DepartmentCode; Rec."Department Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Department Code field.';
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Post)
            {
                Caption = 'Post';
                action(UpdateStock)
                {
                    ApplicationArea = Basic;
                    Caption = 'Update Stock';
                    ToolTip = 'Executes the Update Stock action.';

                    trigger OnAction()
                    begin
                        // Track The Last Entry
                        Rec.TestField("Campus Code");
                        Rec.TestField("Department Code");
                        if ItemLedger.Find('-') then begin
                            ItemLedger.FindLast();
                            LastLedger := ItemLedger."Entry No.";
                        end;
                        // Post The Journal
                        "Post Inventory"();

                        // Update The Menu If Posting Was Done
                        if ItemLedger.Find('-') then begin
                            if LastLedger <> ItemLedger."Entry No." then begin
                                Rec.SetRange("Menu Date", MenuDate);
                                if Rec.Find('-') then begin
                                    repeat
                                        Rec."Remaining Qty" := Rec."Total Qty";
                                        Rec."produced By" := UserId;
                                        Rec.Posted := true;
                                        Rec."Posted Date" := Today;
                                        Rec.Modify;
                                    until Rec.Next = 0;
                                end;
                            end;
                        end;
                    end;
                }
                action(UpdateStockPrintMenu)
                {
                    ApplicationArea = Basic;
                    Caption = 'Update Stock / Print Menu';
                    ToolTip = 'Executes the Update Stock / Print Menu action.';

                    trigger OnAction()
                    begin
                        // Track The Last Entry
                        if ItemLedger.Find('-') then begin
                            ItemLedger.FindLast();
                            LastLedger := ItemLedger."Entry No.";
                        end;
                        // Post The Journal
                        "Post Inventory"();

                        // Print Menu
                        Rec.SetRange("Menu Date", Rec."Menu Date");
                        Report.Run(51161, false, false, Rec);

                        // Update The Menu If Posting Was Done
                        if ItemLedger.Find('-') then begin
                            if LastLedger <> ItemLedger."Entry No." then begin
                                Rec."produced By" := UserId;
                                Rec.Posted := true;
                                Rec."Posted Date" := Today;
                                Rec.Modify;
                            end;
                        end;
                    end;
                }
                action(PreviewMenu)
                {
                    ApplicationArea = Basic;
                    Caption = 'Preview Menu';
                    ToolTip = 'Executes the Preview Menu action.';

                    trigger OnAction()
                    begin
                        Rec.SetRange("Menu Date", Rec."Menu Date");
                        Report.Run(51161, true, true, Rec);
                    end;
                }
            }
        }
        area(processing)
        {
            action(GetLeftOvers)
            {
                ApplicationArea = Basic;
                Caption = 'Get Left Overs';
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Executes the Get Left Overs action.';

                trigger OnAction()
                begin
                    Page.Run(70134731);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        MenuDate := Rec."Menu Date";
    end;

    trigger OnOpenPage()
    begin
        MenuDate := Today;
    end;

    var
        MenuDate: Date;
        MenuRec: Record "Food Menu";
        ITMJnl: Record "Item Journal Line";
        GenSetUp: Record "Catering SetUp";
        "Line No": Integer;
        MenuLine: Record "Food Menu Line";
        str: Code[10];
        ItemLedger: Record "Item Ledger Entry";
        LastLedger: Integer;

    procedure "Post Inventory"()
    begin
        // Test Items To Be posted
        str := '';
        Rec.SetRange("Menu Date", MenuDate);
        Rec.SetFilter(Menu, '<>%1', str);
        if Rec.Find('-') then begin
        end
        else begin
            Error('There is Nothing To Be Posted Make Sure You Have Entered The Menu Date')
        end;
        Rec.TestField("Prod Qty");

        // Clean The Items Journal Line

        GenSetUp.Get();
        ITMJnl.SetRange(ITMJnl."Journal Template Name", GenSetUp."Item Template");
        ITMJnl.SetRange(ITMJnl."Journal Batch Name", GenSetUp."Item Batch");
        if ITMJnl.Find('-') then begin
            repeat
                ITMJnl.Delete;
            until ITMJnl.Next = 0;
        end;

        // Populate The Journal Line
        "Line No" := 10000;
        if Rec.Find('-') then begin
            repeat
                MenuLine.SetRange(MenuLine.Menu, Rec.Menu);
                MenuLine.SetRange(MenuLine.Type, Rec.Type);
                if MenuLine.Find('-') then begin
                    repeat
                        ITMJnl.Init();
                        ITMJnl."Journal Template Name" := GenSetUp."Item Template";
                        ITMJnl."Journal Batch Name" := GenSetUp."Item Batch";
                        ITMJnl."Line No." := "Line No";
                        ITMJnl."Posting Date" := MenuDate;
                        ITMJnl."Entry Type" := ITMJnl."entry type"::"Negative Adjmt.";
                        ITMJnl.Quantity := Rec."Total Qty";
                        ITMJnl."Unit Cost" := Rec."Unit Cost";
                        ITMJnl."Unit Amount" := Rec."Unit Cost";
                        ITMJnl.Amount := Rec."Total Cost";
                        ITMJnl."Location Code" := MenuLine.Location;
                        ITMJnl."Gen. Prod. Posting Group" := 'CATERING';
                        ITMJnl."Gen. Bus. Posting Group" := 'LOCAL';
                        ITMJnl."Item No." := MenuLine."Item No";
                        ITMJnl.Description := MenuLine.Description;
                        ITMJnl."Document No." := Format(Rec."Menu Date") + ' ' + Rec.Menu;
                        ITMJnl.Validate(ITMJnl.Quantity);
                        ITMJnl."Shortcut Dimension 1 Code" := Rec."Campus Code";
                        ITMJnl."Shortcut Dimension 2 Code" := Rec."Department Code";
                        ITMJnl.Insert(true);
                        "Line No" := "Line No" + 10000;
                    until ITMJnl.Next = 0;
                end;
            until Rec.Next = 0;
        end;

        ITMJnl.SetRange(ITMJnl."Journal Template Name", GenSetUp."Item Template");
        ITMJnl.SetRange(ITMJnl."Journal Batch Name", GenSetUp."Item Batch");
        if ITMJnl.Find('-') then begin
            Codeunit.Run(Codeunit::"Item Jnl.-Post", ITMJnl)
        end;
        //MESSAGE('Inventory Updated Successfully');
    end;

    local procedure MenuOnAfterInput(var Text: Text[1024])
    begin
        MenuDate := Rec."Menu Date";
    end;
}

