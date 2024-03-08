//
//  TYTYPE.swift
//  NGSprots
//
//  Created by wen xi on 2023/12/18.
//

import Foundation

func getTYType(key: Int) -> String {
    switch key {
    case 1:
        return "1";
    case 2:
        return "2";
    case 3:
        return "X";
    case 4:
        return "O";
    case 5:
        return "U";
    case 6:
        return "Even";
    case 7:
        return "Odd";
    case 8:
        return "Yes";
    case 9:
        return "No";
    case 10:
        return "W1";
    case 11:
        return "W2";
    case 15:
        return "Exact";
    case 16:
        return "None";
    case 17:
        return "{H}&Over {L}|Home&Over {L}";
    case 18:
        return "{H}&Under {L}|Home&Under {L}";
    case 19:
        return "{A}&Over|Away&Over {L}";
    case 20:
        return "{A}&Under{L}|Away&Under {L}";
    case 21:
        return "Draw&Over {L}";
    case 22:
        return "Draw&Under {L}";
    case 23:
        return "{H}&Yes|Home&Yes";
    case 24:
        return "{H}&No|Home&No";
    case 25:
        return "{A}&Yes|Away&Yes";
    case 26:
        return "{A}&No|Away&No";
    case 27:
        return "Draw&Yes";
    case 28:
        return "Draw&No";
    case 29:
        return "{H}/Draw&Over {L}|Home/Draw&Over {L}";
    case 30:
        return "{H}/Draw&Under {L}|Home/Draw&Under {L}";
    case 31:
        return "{H}/{A}&Over {L}|Home/Away&Over {L}";
    case 32:
        return "{H}/{A}&Under {L}|Home/Away&Under {L}";
    case 33:
        return "{A}/Draw&Over {L}|Away/Draw&Over {L}";
    case 34:
        return "{A}/Draw&Under {L}|Away/Draw&Under {L}";
    case 35:
        return "{H}/Draw|Home/Draw";
    case 36:
        return "{H}/{A}|Home/Away";
    case 37:
        return "{A}/Draw|Away&Draw";
    case 38:
        return "Draw/{H}|Draw/Home";
    case 39:
        return "Draw/{A}|Draw/Away";
    case 40:
        return "{A}/{A}|Away/Away";
    case 41:
        return "{H}&{H}|Home&Home";
    case 42:
        return "{A}/{H}|Away&Home";
    case 43:
        return "Draw/Draw";
    case 44:
        return "{A}/Draw&No|Away/Draw&No";
    case 45:
        return "{H}/{A}&No|Home/Away&No";
    case 46:
        return "{A}/Draw&Yes|Away/Draw&Yes";
    case 47:
        return "{H}/{A}&Yes|Home/Away&Yes";
    case 48:
        return "{H}/Draw&Yes|Home/Draw&Yes";
    case 49:
        return "{H}/Draw&No|Home/Draw&No";
    case 50:
        return "{H}/Draw|Home/Draw";
    case 51:
        return "{H}/{A}|Home/Away";
    case 52:
        return "{A}/Draw|Away/Draw";
    case 53:
        return "1st Half {L}";
    case 54:
        return "2nd Half {L}";
    case 55:
        return "Equal";
    case 56:
        return "No/No";
    case 57:
        return "Yes/No";
    case 58:
        return "Yes/Yes";
    case 59:
        return "No/Yes";
    case 63:
        return "{H} - Win By 1 Goal | Home Win By 1 Goal";
    case 64:
        return "{H} - Win By 2 Goals | Home Win By 2 Goals";
    case 65:
        return "{H} - Win By 3+ Goals | Home Win By 3+ Goals";
    case 66:
        return "{A} - Win By 1 Goal | Away Win By 1 Goal";
    case 67:
        return "{A} - Win By 2 Goals | Away Win By 2 Goals";
    case 68:
        return "{A} - Win By 3+ Goals | Away Win By 3+ Goals";
    case 69:
        return "Draw No Goals";
    case 70:
        return "Draw With Goals";
    case 71:
        return "{H} - Regular Time | Home Regular Time";
    case 72:
        return "{A} - Regular Time | Away Regular Time";
    case 73:
        return "{H} - OT | Home OT";
    case 74:
        return "{A} - OT | Away OT";
    case 75:
        return "{H} - Penalties | Home Penalties";
    case 76:
        return "{A} - Penalties | Away Penalties";
    case 77:
        return "Over {L} & Yes";
    case 78:
        return "Under {L} & Yes";
    case 79:
        return "Over {L} & No";
    case 80:
        return "Under {L} &No";
    case 81:
        return "{H} & {H} {L}th Goal | Home & Home {L}th Goal";
    case 82:
        return "Draw & {H} {L}th Score | Draw & Home {L}th Score";
    case 83:
        return "{A} & {H} {L}th Score | Away & Home {L}th Score";
    case 84:
        return "{H} & {A} {L}thScore | Home & Away {L}th Score";
    case 85:
        return "Draw & {A} {L}th Score | Draw & Away {L}th Score";
    case 86:
        return "{A} & {A} {L}th Score | Away & Away {L}th Score";
    case 87:
        return "No Goal";
    case 88:
        return "Start of 1st Half -14:59 Mins";
    case 89:
        return "15:00 – 29:59 Mins";
    case 90:
        return "30:00 Mins – Half Time";
    case 91:
        return "Start of 2nd Half – 59:59 Mins";
    case 92:
        return "60:00 – 74:59 Mins";
    case 93:
        return "75:00 Mins – Full Time";
    case 94:
        return "Shot";
    case 95:
        return "Header";
    case 96:
        return "Own Goal";
    case 97:
        return "Penalty";
    case 98:
        return "Free Kick";
    case 100:
        return "0-0";
    case 101:
        return "0-1";
    case 103:
        return "0-3";
    case 104:
        return "0-4";
    case 105:
        return "0-5";
    case 106:
        return "0-6";
    case 107:
        return "0-7";
    case 108:
        return "0-8";
    case 109:
        return "0-9";
    case 110:
        return "1-0";
    case 111:
        return "1-1";
    case 112:
        return "1-2";
    case 113:
        return "1-3";
    case 114:
        return "1-4";
    case 115:
        return "1-5";
    case 116:
        return "1-6";
    case 117:
        return "1-7";
    case 118:
        return "1-8";
    case 119:
        return "1-9";
    case 120:
        return "2-0";
    case 121:
        return "2-1";
    case 122:
        return "2-2";
    case 123:
        return "2-3";
    case 124:
        return "2-4";
    case 125:
        return "2-5";
    case 126:
        return "2-6";
    case 127:
        return "2-7";
    case 128:
        return "2-8";
    case 129:
        return "2-9";
    case 130:
        return "3-0";
    case 131:
        return "3-1";
    case 132:
        return "3-2";
    case 133:
        return "3-3";
    case 134:
        return "3-4";
    case 135:
        return "3-5";
    case 136:
        return "3-6";
    case 137:
        return "3-7";
    case 138:
        return "3-8";
    case 139:
        return "3-9";
    case 140:
        return "4-0";
    case 141:
        return "4-1";
    case 142:
        return "4-2";
    case 143:
        return "4-3";
    case 144:
        return "4-4";
    case 145:
        return "4-5";
    case 146:
        return "4-6";
    case 147:
        return "4-7";
    case 148:
        return "4-8";
    case 149:
        return "4-9";
    case 150:
        return "5-0";
    case 151:
        return "5-1";
    case 152:
        return "5-2";
    case 153:
        return "5-3";
    case 154:
        return "5-4";
    case 155:
        return "5-5";
    case 156:
        return "5-6";
    case 157:
        return "5-7";
    case 158:
        return "5-8";
    case 159:
        return "5-9";
    case 160:
        return "6-0";
    case 161:
        return "6-1";
    case 162:
        return "6-2";
    case 163:
        return "6-3";
    case 164:
        return "6-4";
    case 165:
        return "6-5";
    case 166:
        return "6-6";
    case 167:
        return "6-7";
    case 168:
        return "6-8";
    case 169:
        return "6-9";
    case 170:
        return "7-0";
    case 171:
        return "7-1";
    case 172:
        return "7-2";
    case 173:
        return "7-3";
    case 174:
        return "7-4";
    case 175:
        return "7-5";
    case 176:
        return "7-6";
    case 177:
        return "7-7";
    case 178:
        return "7-8";
    case 179:
        return "7-9";
    case 180:
        return "8-0";
    case 181:
        return "8-1";
    case 182:
        return "8-2";
    case 183:
        return "8-3";
    case 184:
        return "8-4";
    case 185:
        return "8-5";
    case 186:
        return "8-6";
    case 187:
        return "8-7";
    case 188:
        return "8-8";
    case 189:
        return "8-9";
    case 190:
        return "9-0";
    case 191:
        return "9-1";
    case 192:
        return "9-2";
    case 193:
        return "9-3";
    case 194:
        return "9-4";
    case 195:
        return "9-5";
    case 196:
        return "9-6";
    case 197:
        return "9-7";
    case 198:
        return "9-8";
    case 199:
        return "9-9";
    case 222,244,277:
        return "Others";
    case 300:
        return "0-0";
    case 301:
        return "0-1";
    case 302:
        return "2-3";
    case 303:
        return "4-6";
    case 304:
        return "6+";
    case 305:
        return "7+";
    case 306:
        return "3+";
    case 311:
        return "0";
    case 312:
        return "1";
    case 313:
        return "2";
    case 314:
        return "3";
    case 315:
        return "4";
    case 316:
        return "5";
    case 317:
        return "6";
    case 318:
        return "7";
    case 319:
        return "8";
    case 320:
        return "2+";
    case 321:
        return "3+";
    case 327:
        return "4+";
    case 322:
        return "6+";
    case 323:
        return "9+";
    case 330:
        return "0-2";
    case 331:
        return "0-4";
    case 332:
        return "0-8";
    case 333:
        return "3-4";
    case 334:
        return "5-6";
    case 335:
        return "9-11";
    case 336:
        return "7+";
    case 337:
        return "12+";
    case 338:
        return "0-150";
    case 339:
        return "151-160";
    case 340:
        return "161-170";
    case 341:
        return "171-180";
    case 342:
        return "181-190";
    case 343:
        return "191-200";
    case 344:
        return "201-210";
    case 345:
        return "211-220";
    case 346:
        return "221-230";
    case 347:
        return "231-240";
    case 348:
        return "241-250";
    case 349:
        return "250.5+";
    case 350:
        return "{H} Win By1-5 Points | Home Win By1-5 Points";
    case 351:
        return "{H} Win By6-10 Points | Home Win By6-10 Points";
    case 352:
        return "{H} Win By 11-15 Points | Home Win By 11-15 Points";
    case 353:
        return "{H} Win By 16-20 Points | Home Win By 16-20 Points";
    case 354:
        return "{H} Win By 21-25 Points | Home Win By 21-25 Points";
    case 355:
        return "{H} Win By 26+ Points | Home Win By 26+ Points";
    case 356:
        return "{A} Win By 1-5 Points | Away Win By 1-5 Points";
    case 357:
        return "{A} Win By 6-10 Points | Away Win By 6-10 Points";
    case 358:
        return "{A} Win By 11-15 Points | Away Win By 11-15 Points";
    case 359:
        return "{A} Win By 16-20 Points | Away Win By 16-20 Points";
    case 360:
        return "{A} Win By 21-25 Points | Away Win By 21-25 Points";
    case 361:
        return "{A} Win By 26+ Points | Away Win By 26+ Points";
    case 362:
        return "{H} Win By 3+ Points | Home Win By 3+ Points";
    case 363:
        return "{A} Win By 3+ Points | Away Win By 3+ Points";
    case 364:
        return "Other";
    case 365:
        return "1st Quarter";
    case 366:
        return "2nd Quarter";
    case 367:
        return "3st Quarter";
    case 368:
        return "4nd Quarter";
    case 369:
        return "Only {H} | Only Home";
    case 370:
        return "Only {A} | Only Away";
    case 371:
        return "Both Teams";
    case 255:
        return "Others";
    case 324:
        return "10+";
    case 325:
        return "0-4";
    case 326:
        return "9";
    case 372:
        return "{H} 1 Point | Home 1 Point";
    case 373:
        return "{H} 2 Point | Home 2 Point";
    case 374:
        return "{H} 3 Point | Home 3 Point";
    case 375:
        return "{A} 1 Point | Away 1 Point";
    case 376:
        return "{A} 2 Point | Away 2 Point";
    case 377:
        return "{A} 3 Point | Away 3 Point";
    case 378:
        return "1 Point";
    case 379:
        return "2 Point";
    case 380:
        return "3 Point";
    case 381:
        return "1st Period";
    case 382:
        return "2nd Period";
    case 383:
        return "3nd Period";
    case 384:
        return "3rd Round";
    case 385:
        return "4th Round";
    case 386:
        return "5th Round";
    case 387:
        return "6th Round or Later";
    case 400:
        return "HOME BY KO";
    case 401:
        return "HOME BY DECISION";
    case 402:
        return "AWAY BY KO";
    case 403:
        return "AWAY BY DECISION";
    case 404:
        return "HOME BY SUBMISSION";
    case 405:
        return "AWAY BY SUBMISSION";
    case 406:
        return "Red";
    case 407:
        return "Yellow";
    case 408:
        return "Green";
    case 409:
        return "Brown";
    case 410:
        return "Blue";
    case 411:
        return "Pink";
    case 412:
        return "Black";
    case 413:
        return "Foul";
    case 414:
        return "Touchdown";
    case 415:
        return "Field Goal";
    case 416:
        return "Safety";
    case 420:
        return "0-2";
    case 421:
        return "0-3";
    case 422:
        return "0-4";
    case 423:
        return "0-5";
    case 424:
        return "0-6";
    case 425:
        return "1-1";
    case 426:
        return "1-2";
    case 427:
        return "1-3";
    case 428:
        return "1-4";
    case 429:
        return "1-5";
    case 430:
        return "1-6";
    case 431:
        return "2-2";
    case 432:
        return "2-4";
    case 433:
        return "2-5";
    case 434:
        return "2-6";
    case 435:
        return "3-3";
    case 436:
        return "3-4";
    case 437:
        return "3-5";
    case 438:
        return "3-6";
    case 439:
        return "4-4";
    case 440:
        return "4-5";
    case 441:
        return "5-5";
    case 442:
        return "5-6";
    case 443:
        return "6-6";
    case 448:
        return "0";
    case 449:
        return "1";
    case 450:
        return "0-3";
    case 451:
        return "4";
    case 452:
        return "5";
    case 453:
        return "6";
    case 454:
        return "7";
    case 455:
        return "8";
    case 456:
        return "9";
    case 457:
        return "10";
    case 458:
        return "11";
    case 459:
        return "12+";
    case 460:
        return "0-1";
    case 461:
        return "2";
    case 462:
        return "3";
    case 463:
        return "4+";
    case 464:
        return "3+";
    case 465:
        return "6+";
    case 501:
        return "1,{T1}";
    case 502:
        return "2,{T2}";
    case 503:
        return "3,{T3}";
    case 504:
        return "4,{T4}";
    case 505:
        return "5,{T5}";
    case 506:
        return "6,{T6}";
    case 521:
        return "1,2";
    case 522:
        return "1,3";
    case 523:
        return "1,4";
    case 524:
        return "1,5";
    case 525:
        return "1,6";
    case 526:
        return "2,1";
    case 527:
        return "2,3";
    case 528:
        return "2,4";
    case 529:
        return "2,5";
    case 530:
        return "2,6";
    case 531:
        return "3,1";
    case 532:
        return "3,2";
    case 533:
        return "3,4";
    case 534:
        return "3,5";
    case 535:
        return "3,6";
    case 536:
        return "4,1";
    case 537:
        return "4,2";
    case 538:
        return "4,3";
    case 539:
        return "4,5";
    case 540:
        return "4,6";
    case 541:
        return "5,1";
    case 542:
        return "5,2";
    case 543:
        return "5,3";
    case 544:
        return "5,4";
    case 545:
        return "5,6";
    case 546:
        return "6,1";
    case 547:
        return "6,2";
    case 548:
        return "6,3";
    case 549:
        return "6,4";
    case 550:
        return "6,5";
    case 551:
        return "1,2";
    case 552:
        return "1,3";
    case 553:
        return "1,4";
    case 554:
        return "1,5";
    case 555:
        return "1,6";
    case 556:
        return "2,3";
    case 557:
        return "2,4";
    case 558:
        return "2,5";
    case 559:
        return "2,6";
    case 560:
        return "3,4";
    case 561:
        return "3,5";
    case 562:
        return "3,6";
    case 563:
        return "4,5";
    case 564:
        return "4,6";
    case 565:
        return "5,6";
    case 600:
        return "0-0 / 0-0";
    case 601:
        return "0-0 / 0-1";
    case 602:
        return "0-0 / 0-2";
    case 603:
        return "0-0 / 0-3";
    case 604:
        return "0-0 / 1-0";
    case 605:
        return "0-0 / 1-1";
    case 606:
        return "0-0 / 1-2";
    case 607:
        return "0-0 / 2-0";
    case 608:
        return "0-0 / 2-1";
    case 609:
        return "0-0 / 3-0";
    case 610:
        return "0-0 / 4+";
    case 611:
        return "0-1 / 0-1";
    case 612:
        return "0-1 / 0-2";
    case 613:
        return "0-1 / 0-3";
    case 614:
        return "0-1 / 1-1";
    case 615:
        return "0-1 / 1-2";
    case 616:
        return "0-1 / 2-1";
    case 617:
        return "0-1 / 4+";
    case 618:
        return "0-2 / 0-2";
    case 619:
        return "0-2 / 0-3";
    case 620:
        return "0-2 / 1-2";
    case 621:
        return "0-2 / 4+";
    case 622:
        return "0-3 / 0-3";
    case 623:
        return "0-3 / 4+";
    case 624:
        return "1-0 / 1-0";
    case 625:
        return "1-0 / 1-1";
    case 626:
        return "1-0 / 1-2";
    case 627:
        return "1-0 / 2-0";
    case 628:
        return "1-0 / 2-1";
    case 629:
        return "1-0 / 3-0";
    case 630:
        return "1-0 / 4+";
    case 631:
        return "1-1 / 1-1";
    case 632:
        return "1-1 / 1-2";
    case 633:
        return "1-1 / 2-1";
    case 634:
        return "1-1 / 4+";
    case 635:
        return "1-2 / 1-2";
    case 636:
        return "1-2 / 4+";
    case 637:
        return "2-0 / 2-0";
    case 638:
        return "2-0 / 2-1";
    case 639:
        return "2-0 / 3-0";
    case 640:
        return "2-0 / 4+";
    case 641:
        return "2-1 / 2-1";
    case 642:
        return "2-1 / 4+";
    case 643:
        return "3-0 / 3-0";
    case 644:
        return "3-0 / 4+";
    case 645:
        return "4+ / 4+";
    case 650:
        return "0";
    case 651:
        return "1";
    case 652:
        return "2";
    case 653:
        return "3";
    case 654:
        return "4";
    case 655:
        return "5";
    case 656:
        return "6";
    case 657:
        return "7";
    case 658:
        return "8";
    case 659:
        return "9";
    case 660:
        return "Odd/Odd/Odd/Odd";
    case 661:
        return "Odd/Odd/Odd/Even";
    case 662:
        return "Odd/Odd/Even/Odd";
    case 663:
        return "Odd/Even/Odd/Odd";
    case 664:
        return "Even/Odd/Odd/Odd";
    case 665:
        return "Even/Even/Even/Even";
    case 666:
        return "Even/Even/Even/Odd";
    case 667:
        return "Even/Even/Odd/Even";
    case 668:
        return "Even/Odd/Even/Even";
    case 669:
        return "Odd/Even/Even/Even";
    case 670:
        return "Odd/Odd/Even/Even";
    case 671:
        return "Odd/Even/Odd/Even";
    case 672:
        return "Even/Odd/Even/Odd";
    case 673:
        return "Even/Even/Odd/Odd";
    case 674:
        return "Even/Odd/Odd/Even";
    case 675:
        return "Odd/Even/Even/Odd";
    case 676:
        return "Caught";
    case 677:
        return "Bowled";
    case 678:
        return "LBW";
    case 679:
        return "Run Out";
    case 680:
        return "Stumped";
    case 681:
        return "Others";
    case 682:
        return "Not Caught";
    case 683:
        return "Home {L1} & Over {L2}";
    case 684:
        return "Home {L1} & Under {L2}";
    case 685:
        return "Away {L1} & Over {L2}";
    case 686:
        return "Away {L1} & Under {L2}";
    default:
        return ""
    }
}
