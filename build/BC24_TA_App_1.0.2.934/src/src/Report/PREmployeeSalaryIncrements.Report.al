report 50114 "PR Employee Salary Increments"
{
    // version Agile Payroll

    ProcessingOnly = true;
    ApplicationArea = All;

    dataset
    {
        dataitem("HR-Employee"; "HR-Employee")
        {
            DataItemTableView = SORTING("No.")
                                ORDER(Descending)
                                WHERE(Status = CONST(Active));

            trigger OnAfterGetRecord();
            begin

                IF IncrementalMonth = 0 THEN ERROR('Please specify Incremental Month on the request page');

                //FILTER BY PRE DEFINED FILTERS ON THE REQUEST PAGE
                HREmp.RESET;
                HREmp.SETRANGE(HREmp.Status, HREmp.Status::Active);
                HREmp.SETRANGE(HREmp."Salary Incremental Month", IncrementalMonth);
                IF HREmp.FIND('-') THEN
                    REPEAT

                        i := i + 1;

                        IF HREmp."Date Of Joining the Company" = 0D THEN BEGIN
                            ERROR(Text001, HREmp."No.", HREmp."Full Name");
                        END;

                        yearJ := DATE2DMY(HREmp."Date Of Joining the Company", 3);
                        yearToday := DATE2DMY(TODAY, 3);
                        LOS := yearToday - yearJ;


                        IF LOS > 0 THEN BEGIN
                            CurrentEmployeeBasicPay := HREmp."Basic Pay";
                            CurrEmployeeName := HREmp."Full Name";
                            CurrentEmployeeJobGroup := HREmp."Job Group";

                            // TIER 1
                            PRSalaryScale.RESET;
                            PRSalaryScale.SETRANGE(PRSalaryScale."Job Group", CurrentEmployeeJobGroup);
                            PRSalaryScale.SETRANGE(PRSalaryScale."Pointer 1 - Minimum", CurrentEmployeeBasicPay);
                            IF PRSalaryScale.FIND('-') THEN BEGIN
                                NewEmployeeBasicPay := PRSalaryScale."Pointer 2";

                                //MODIFY BASIC PAY OF EMPLOYEE
                                HREmp2.RESET;
                                HREmp2.SETRANGE(HREmp2."No.", HREmp."No.");
                                IF HREmp2.FIND('-') THEN BEGIN
                                    HREmp2."New Basic Pay" := NewEmployeeBasicPay;
                                    HREmp2.MODIFY;
                                END;

                            END;

                            // TIER 2
                            PRSalaryScale.RESET;
                            PRSalaryScale.SETRANGE(PRSalaryScale."Job Group", CurrentEmployeeJobGroup);
                            PRSalaryScale.SETRANGE(PRSalaryScale."Pointer 2", CurrentEmployeeBasicPay);
                            IF PRSalaryScale.FIND('-') THEN BEGIN
                                NewEmployeeBasicPay := PRSalaryScale."Pointer 3";

                                //MODIFY BASIC PAY OF EMPLOYEE
                                HREmp2.RESET;
                                HREmp2.SETRANGE(HREmp2."No.", HREmp."No.");
                                IF HREmp2.FIND('-') THEN BEGIN
                                    HREmp2."New Basic Pay" := NewEmployeeBasicPay;
                                    HREmp2.MODIFY;
                                END;

                            END;

                            // TIER 3
                            PRSalaryScale.RESET;
                            PRSalaryScale.SETRANGE(PRSalaryScale."Job Group", CurrentEmployeeJobGroup);
                            PRSalaryScale.SETRANGE(PRSalaryScale."Pointer 3", CurrentEmployeeBasicPay);
                            IF PRSalaryScale.FIND('-') THEN BEGIN
                                NewEmployeeBasicPay := PRSalaryScale."Pointer 4";

                                //MODIFY BASIC PAY OF EMPLOYEE
                                HREmp2.RESET;
                                HREmp2.SETRANGE(HREmp2."No.", HREmp."No.");
                                IF HREmp2.FIND('-') THEN BEGIN
                                    HREmp2."New Basic Pay" := NewEmployeeBasicPay;
                                    HREmp2.MODIFY;
                                END;

                            END;

                            // TIER 4
                            PRSalaryScale.RESET;
                            PRSalaryScale.SETRANGE(PRSalaryScale."Job Group", CurrentEmployeeJobGroup);
                            PRSalaryScale.SETRANGE(PRSalaryScale."Pointer 4", CurrentEmployeeBasicPay);
                            IF PRSalaryScale.FIND('-') THEN BEGIN
                                NewEmployeeBasicPay := PRSalaryScale."Pointer 5";

                                //MODIFY BASIC PAY OF EMPLOYEE
                                HREmp2.RESET;
                                HREmp2.SETRANGE(HREmp2."No.", HREmp."No.");
                                IF HREmp2.FIND('-') THEN BEGIN
                                    HREmp2."New Basic Pay" := NewEmployeeBasicPay;
                                    HREmp2.MODIFY;
                                END;

                            END;

                            // TIER 5
                            PRSalaryScale.RESET;
                            PRSalaryScale.SETRANGE(PRSalaryScale."Job Group", CurrentEmployeeJobGroup);
                            PRSalaryScale.SETRANGE(PRSalaryScale."Pointer 5", CurrentEmployeeBasicPay);
                            IF PRSalaryScale.FIND('-') THEN BEGIN
                                NewEmployeeBasicPay := PRSalaryScale."Pointer 6";

                                //MODIFY BASIC PAY OF EMPLOYEE
                                HREmp2.RESET;
                                HREmp2.SETRANGE(HREmp2."No.", HREmp."No.");
                                IF HREmp2.FIND('-') THEN BEGIN
                                    HREmp2."New Basic Pay" := NewEmployeeBasicPay;
                                    HREmp2.MODIFY;
                                END;


                            END;

                            // TIER 6
                            PRSalaryScale.RESET;
                            PRSalaryScale.SETRANGE(PRSalaryScale."Job Group", CurrentEmployeeJobGroup);
                            PRSalaryScale.SETRANGE(PRSalaryScale."Pointer 6", CurrentEmployeeBasicPay);
                            IF PRSalaryScale.FIND('-') THEN BEGIN
                                NewEmployeeBasicPay := PRSalaryScale."Pointer 7";

                                //MODIFY BASIC PAY OF EMPLOYEE
                                HREmp2.RESET;
                                HREmp2.SETRANGE(HREmp2."No.", HREmp."No.");
                                IF HREmp2.FIND('-') THEN BEGIN
                                    HREmp2."New Basic Pay" := NewEmployeeBasicPay;
                                    HREmp2.MODIFY;
                                END;

                            END;

                            // TIER 7
                            PRSalaryScale.RESET;
                            PRSalaryScale.SETRANGE(PRSalaryScale."Job Group", CurrentEmployeeJobGroup);
                            PRSalaryScale.SETRANGE(PRSalaryScale."Pointer 7", CurrentEmployeeBasicPay);
                            IF PRSalaryScale.FIND('-') THEN BEGIN
                                NewEmployeeBasicPay := PRSalaryScale."Pointer 8";

                                //MODIFY BASIC PAY OF EMPLOYEE
                                HREmp2.RESET;
                                HREmp2.SETRANGE(HREmp2."No.", HREmp."No.");
                                IF HREmp2.FIND('-') THEN BEGIN
                                    HREmp2."New Basic Pay" := NewEmployeeBasicPay;
                                    HREmp2.MODIFY;
                                END;
                            END;

                            // TIER 8
                            PRSalaryScale.RESET;
                            PRSalaryScale.SETRANGE(PRSalaryScale."Job Group", CurrentEmployeeJobGroup);
                            PRSalaryScale.SETRANGE(PRSalaryScale."Pointer 8", CurrentEmployeeBasicPay);
                            IF PRSalaryScale.FIND('-') THEN BEGIN
                                NewEmployeeBasicPay := PRSalaryScale."Pointer 9";

                                //MODIFY BASIC PAY OF EMPLOYEE
                                HREmp2.RESET;
                                HREmp2.SETRANGE(HREmp2."No.", HREmp."No.");
                                IF HREmp2.FIND('-') THEN BEGIN
                                    HREmp2."New Basic Pay" := NewEmployeeBasicPay;
                                    HREmp2.MODIFY;
                                END;

                            END;

                            // TIER 9
                            PRSalaryScale.RESET;
                            PRSalaryScale.SETRANGE(PRSalaryScale."Job Group", CurrentEmployeeJobGroup);
                            PRSalaryScale.SETRANGE(PRSalaryScale."Pointer 9", CurrentEmployeeBasicPay);
                            IF PRSalaryScale.FIND('-') THEN BEGIN
                                NewEmployeeBasicPay := CurrentEmployeeBasicPay;

                                HREmp."New Basic Pay" := NewEmployeeBasicPay;
                                HREmp.MODIFY;
                            END;
                        END;
                    UNTIL HREmp.NEXT = 0;
            end;

            trigger OnPostDataItem();
            begin
                MESSAGE(Text002);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {

                group("PR Basic Salary Increments")
                {
                    Caption = 'PR Basic Salary Increments';

                    field(IncrementalMonth; IncrementalMonth)
                    {
                        Caption = 'Incremental Month';
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Incremental Month field.';
                    }
                }
            }
        }

        actions { }
    }

    labels { }

    trigger OnInitReport();
    begin

    end;

    trigger OnPreReport();
    begin


        //To Clear New Basic
        HREmp2.RESET;
        IF HREmp2.FINDFIRST THEN BEGIN
            REPEAT
                HREmp2."New Basic Pay" := 0;
                HREmp2.MODIFY;
            UNTIL HREmp2.NEXT = 0;
        END;
    end;

    var

        IncrementalMonth: Option ,January,February,March,April,May,June,July,August,September,October,November,December;
        HREmp: Record "HR-Employee";
        i: Integer;

        yearJ: Integer;
        yearToday: Integer;
        LOS: Integer;
        CurrentEmployeeBasicPay: Decimal;
        NewEmployeeBasicPay: Decimal;
        CurrentEmployeeJobGroup: Code[20];
        PRSalaryScale: Record "PR Employees Salary Scale";
        HREmp2: Record "HR-Employee";
        Text001: Label 'Date Of Joining the Company must have value in Employee %1 - %2';
        Text002: Label 'Update Complete';
        CurrEmployeeName: Text;


}

