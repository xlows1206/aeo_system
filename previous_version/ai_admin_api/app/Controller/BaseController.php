<?php

declare(strict_types=1);

namespace App\Controller;

use Hyperf\Di\Annotation\Inject;
use App\Service\Response\ResponseServiceInterface;

abstract class BaseController
{
    #[Inject]
    protected ResponseServiceInterface $responseService;
}
