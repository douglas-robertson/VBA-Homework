Attribute VB_Name = "MultipleYearAnalysis"

Sub multiple_year_stock_data_analysis():

   ' Create loop for all worksheets
    For Each ws In Worksheets
    Set sht = ws
    
    'Print result column and results table titlesheaders
    ws.Cells(1, 9) = "Ticker"
    ws.Cells(1, 10) = "Yearly Change"
    ws.Cells(1, 11) = "Percent Change"
    ws.Cells(1, 12) = "Total Stock Volume"
    ws.Cells(1, 16) = "Ticker"
    ws.Cells(1, 17) = "Value"
    ws.Cells(2, 15) = "Greatest % Increase"
    ws.Cells(3, 15) = "Greatest % Decrease"
    ws.Cells(4, 15) = "Greatest Total Volume"

    ' Set Variables
    Dim Ticker As String
    Dim GreatestIncTicker As String
    Dim GreatestDecTciker As String
    Dim GreatestVol As String
    Dim LastRow As Long
    Dim VolumeCounter As Double
    Dim RowCounter As Long
    Dim YearlyChange As Double
    Dim YOpen As Double
    Dim YClose As Double
    Dim PercentChange As Double
    Dim PreviousCounter As Long
    Dim LastRowTicker As Integer
    Dim rng As Range
    Dim condition1 As FormatCondition, condition2 As FormatCondition
    

    ' Create last row variable for each worksheet
    LastRow = ws.Cells(sht.Rows.Count, "A").End(xlUp).Row
    LastRowTicker = ws.Cells(sht.Rows.Count, "I").End(xlUp).Row
        ' MsgBox LastRow
        ' MsgBox LastRowTicker

    ' Set variable defaults
    TotalTickerVolume = 0
    RowCounter = 2
    PreviousCounter = 2
        
    ' Set percentages column to the correct number format
    ws.Range("K:K").NumberFormat = "0.00%"
    ws.Range("Q2:Q3").NumberFormat = "0.00%"
    


'---------------Part 1: The Ticker Symbol Linked to Volume Counter ----------------------


        For i = 2 To LastRow

            ' Create volume counter. Volume counter stops counting with ticker values on below row and not equal
            VolumeCounter = VolumeCounter + ws.Cells(i, 7).Value
            If ws.Cells(i + 1, 1).Value <> ws.Cells(i, 1).Value Then
                Ticker = ws.Cells(i, 1).Value
                
                ' Print ticker and volume to table
                ws.Range("I" & RowCounter).Value = Ticker
                ws.Range("L" & RowCounter).Value = VolumeCounter
                
                ' Rester counter
                VolumeCounter = 0

'-----------------Part 2: Percent Change Calculator using yearly change--------------

                ' Create open and close variables and link to yearly change. Counter to log previous values
                YClose = ws.Range("F" & i)
                YOpen = ws.Range("C" & PreviousCounter)
                
                YearlyChange = YClose - YOpen
                ws.Range("J" & RowCounter).Value = YearlyChange

                ' Stops divide by 0 error if any 0 values
                If YOpen = 0 Then
                    PercentChange = 0
                
                Else
                    YOpen = ws.Range("C" & PreviousCounter)
                    PercentChange = YearlyChange / YOpen
                End If
                
                ' Print value into the table
                ws.Range("K" & RowCounter).Value = PercentChange
       
                        
                ' Add One To The Summary Table Row
                RowCounter = RowCounter + 1
                PreviousCounter = i + 1
                End If
            Next i

'----------------- Challenge ---------------------


            ' Use Excel's max/min function on the percent change column
            ws.Cells(2, 17).Value = Application.WorksheetFunction.Max(Range("K:K"))
            ws.Cells(3, 17).Value = Application.WorksheetFunction.Min(Range("K:K"))
    
            ' Great total volume calculation
            ws.Cells(4, 17).Value = Application.WorksheetFunction.Max(Range("L:L"))
    
            'Producing Ticker Value with if statement, if the cell value is equal to another then trigger statement
            For p = 2 To LastRow
                
                ' Greatest % Increase Ticker Calc
                If ws.Cells(2, 17).Value = ws.Cells(p, 11).Value Then
                    GreatestIncTicker = ws.Cells(p, 9).Value
                    ws.Cells(2, 16).Value = GreatestIncTicker
                Else
                
                End If
        
            ' Greatest % Decrease Ticker Calc
            If ws.Cells(3, 17).Value = ws.Cells(p, 11).Value Then
                GreatestDecTciker = ws.Cells(p, 9).Value
                ws.Cells(3, 16).Value = GreatestDecTciker
            
            Else
            
            End If
        
            ' Greatest Total Volume Calc
            If ws.Cells(4, 17).Value = ws.Cells(p, 12).Value Then
                GreatestVol = ws.Cells(p, 9).Value
                ws.Cells(4, 16).Value = GreatestVol
            Else
            
            End If
    
        Next p




'----------------------- Conditional Formtatting ----------------------




                ' Fixing/Setting the range on which conditional formatting is to be desired
                Set rng = ws.Range("J2:J1000")

                ' To delete/clear any existing conditional formatting from the range
                rng.FormatConditions.Delete

                ' Defining and setting the criteria for each conditional format
                Set condition1 = rng.FormatConditions.Add(xlCellValue, xlGreater, "=0")
                Set condition2 = rng.FormatConditions.Add(xlCellValue, xlLess, "=0")

                'Defining and setting the format to be applied for each condition
                With condition1
                    .Interior.ColorIndex = 4
                End With

                With condition2
                    .Interior.ColorIndex = 3
      
                End With


' ---------------------General resets and fitting--------------------------

                ' Reset header color to white
                ws.Cells(1, 10).Interior.ColorIndex = 2
                
                ' Fit all columns to a viewable size
                ws.Cells.EntireColumn.AutoFit
    Next ws

End Sub

